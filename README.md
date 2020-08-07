# comparator
For numerical comparing alternative options

## File Format
The argument to the program is a file in the following format:
```
,attr1[5],attr2[^2]
item1,76,22
item2,70,35
item3,78,9
item4,80,0
item5,3,234
```
### First Row
Empty space, followed by an arbitrary numer of cells. The portion before the left bracket '[' is considered the name of an attribute to be used in the compairison, the part inside the brackets is the weight of that attribute, this must be an integer. If the integer is preceded by '^' it indicates that that attribute is more desirable the less its numerical value is.

### Following rows
The name of the alternative followed by exactly as many numeric value cells as there were attributes defined. You can have as many of these rows as you want.

## Improvements
- Add non linear relationships between best and worst attribute values
- Add the possibility the define a peak in the middle of a set of attributes, as opposed to just the highest or lowest
- Fix formatting so final output is aligned