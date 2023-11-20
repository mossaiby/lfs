# lfs
My Linux from scratch script!

1. Installing linux kernel dependencies, depending on your linux distribution.
2. Edit `lfs.sh` and change `KERNEL_VERSION`, `BUSYBOX_VERSION` or `TASKS` as you want.
3. Run the following command to build kernel and initrd:

```bash
./lfs.sh
```

4. Test the system with `qemu`:
```bash
./qemu
```

5. Have fun!