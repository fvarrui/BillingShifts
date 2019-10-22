# Billing Shifts

Restful API service in Ruby to process the billing of employees.

## Worked shifts

The endpoint will receive a list of worked shifts, which are basically a list of start and end datetime pairs. For example, to represent a shift was worked on the 1st of August of 2019, from 8:00 to 14:00 you would send it as:

```json
{"id": 1, "start": "2019- 08 - 01 08 : 0 0:00", "end":"2019- 08 - 01 14 : 00 :00"}
```

- The shift maximum duration can be assumed to be 24 hours
- Shifts can start in one day and end in the following day
- A shift can’t end before it starts


## Billing rules

In order to give the worked shifts a price you will need to apply billing rules. You will also be sending these on each request to the API. Billing rules contains two main items: conditions and payrate.

- The conditions stablish how ‘when’ and ‘which portion’ of a shift needs to be priced.
- The payrate stablish what’s the price of that portion of shift:
    * For simplicity, prices don’t have currency and we will simply refer to it as units.
    * Payrates are always defined on units per hour.

There are two types of billing rules, depending on how their conditions are defined:

### FIXED

The conditions are two fixed times: start and end. Any worked shift that spans in between these
two times, should be applied this rule.

Let’s illustrate this with an example:

Another important fact about the fixed duration rule is that the start doesn’t have to be before
the end time. This is important when working with overnight shifts.

Given this shift:

```json
{"id": 1, "start": "2019- 08 - 01 08:00:00", "end":"2019- 08 - 01 14:00:00"}
```

And this FIXED rule:

```json
{"id": 1, "type": "FIXED", "payRate": 10.0, "start": "09:00", "end": "11:00"}
```

The rule should be applied to the portion of the shift that goes from 09:00 to 11:00 (2 hours).

The rest of the shift (the portion that goes from 08:00 to 09:00 and the portion that goes from 11:00 to 14:00) is not given any price, since the rule doesn’t apply to it.

The price of this shift for this rule is:

**10.0 (units / hour) * 2 (hours) = 20 (units)**

Let’s illustrate this with another example:

Given this shift:

```json
{"id": 1, "start": "2019- 08 - 01 20 :00:00", "end":"2019- 08 - 02 08 :00:00"}
```

And this FIXED rule:

```json
{"id":1, "type": "FIXED", "payRate": 10.0, "start": "16:00", "end": "07:00"}
```

The rule should be applied to the portion of the shift that goes from 20 :00 (of the starting
day) to 07 :00 (of the following day), which means a portion duration of 11 hours.

The rest of the shift (the portion that goes from 0 7 :00 to 0 8 :00 (of the following day) is not
given any price, since the rule doesn’t apply to it).

Additionally, the portion between 16:00 to 20:00 is defined by the rule, but it doesn’t apply
to the shift because the shift only starts at 20:00 (of the first day).

The price of this shift for this rule is:

**10.0 (units / hour) * 11 (hours) = 11 0 (units)**

### DURATION

The conditions are two durations: **start** and **end**. Any worked shift that has a duration that falls
between these two times, should be applied this rule. Durations are always expressed in seconds.

Let’s illustrate this with an example:

Other billing rules considerations:

- Several billing rules can be applied to the same shift. This means that if two or more rules apply to the same shift, the price obtained from applying each rule will be summed together towards the total value of the shift.
- There can be rules defined in your input that don’t apply to any shift, and this is totally fine.
- There can be shifts defined in your input that can’t be applied any rule, and this is totally fine. Assume the price for the shift is 0 (zero) on these cases.

## Billed shifts

The result of applying rules for worked shifts is what we call “billed shifts” and that’s what your endpoint should return in the response. Apart from the shift’s original data (id, start and end), a billed shift also contains the following fields:

- **session**: Difference in seconds between the start and the end of the shift (shift duration)
- **pay**: The total units to pay to the worker for the shift. It depends on the applied rules, and it is calculated accumulating pay values in the “portions” section (the total price of the shift).

Given this shift:

```json
{"id": 1, "start": "2019- 08 - 01 1 0:00:00", "end":"2019- 08 - 01 1 8:00:00"}
```

And this DURATION rule:

```json
{"id":1, "type": "DURATION", "payRate": 10 .0, "start": 21600 , "end": 32400 }
```

The rule should be applied to the portion of the shift that goes from 16 :00 to 1 8 :00, which means a portion duration of 2 hours.

The rest of the shift (the portion that goes from 1 0:00 to 16 :00 is not given any price, since the rule doesn’t apply to it. This is because there is not ‘enough duration yet’ accumulated on the shift until 16:00. And while the rule would still be applying after 18:00 (for one more hour) the shift has finished at 18:00.

The price of this shift for this rule is:

```
10.0 (units / hour) * 2 (hours) = 20 (units)
```

- **portions**: The breakdown of the applied rules to the shift. This is a list of “portions” and it contains as many item (portions) as rules were applied to the shift (can be seen as shift price subtotals). A “portion” is defined as following:
    * id: Rule id
    * start: Time when the rule starts to be applied (the portion's start)
    * end: Time when the rule ends to be applied (the portions's end)
    * session: Total amount of seconds of the portion
    * pay: The units to pay to the worker (monetary value) for this portion
