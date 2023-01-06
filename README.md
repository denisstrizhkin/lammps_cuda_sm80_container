# lammps_cuda_sm80_container

## build

```bash
$ docker build -t lammps-gpu ./
```

## run

```bash
$ docker run -v $(pwd):/data --gpus all -i lammps-gpu bash -ci 'lmp -in input.in'
```