## 2024-05-22 - Magisk Property Setting Optimization
**Learning:** Using `system.prop` is more efficient than calling `resetprop` multiple times in a shell script. `system.prop` is handled natively by Magisk (likely batched), avoiding the overhead of spawning a shell and multiple `resetprop` processes (fork/exec).
**Action:** When optimizing Magisk modules, check `post-fs-data.sh` for static `resetprop` calls and move them to `system.prop` if possible.
