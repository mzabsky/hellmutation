Console commands
===========================
```
give hm_dna
```
Gives a DNA to the player who entered the command.

```
hm_add <mutation>
```
Activates a mutation with given key. Key is generally the name, in lower case and without spaces or dashes. This mutation cannot be removed without use of hm_remove net command, unless it is
among the mutations offered for removal in the current level or it comes up in an removal offer in a later level.


```
hm_remove <mutation>
```
Immediately deactivates the mutation with given key. Key is generally the name, in lower case and without spaces or dashes.

```
hm_addall
```
Immediately activates all mutations (including those that are not legal in the current level/IWAD).


```
hm_clear
```
Clears active mutations (they don't count as removed, and can be drawn again).