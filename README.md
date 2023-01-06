# lammps_cuda_sm80_container

## build

```bash
$ docker build -t lammps-gpu ./
```

## run

```bash
$ docker run -v $(pwd):/data --gpus all -i --name lmp-gpu-1 lammps-gpu bash -ci 'lmp -in input.in'
```
