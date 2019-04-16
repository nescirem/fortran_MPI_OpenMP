# Coding with MPI and OpenMP

Notes of hybrid parallel programming with Fortran on Windows platform. [[中文版](./README_cn.md)]



## Installations

- OS: Windows 10
- IDE: Visual Studio 2017
- Compeller: Intel Visual Fortran 2019
- Software: MPICH2


# Example codes

## MPI

- [x] [[HELLO WORLD][mpi_hello_world]]
- [ ] [mpi_send][]
- [ ] [mpi_recv][]
- [ ] [mpi_sendrecv][]
- [ ] [mpi_bsend][]
- [ ] [mpi_ssend][]
- [ ] [mpi_rsend][]
- [ ] [mpi_isend][]
- [ ] [mpi_ibsend][]
- [ ] [mpi_issend][]
- [ ] [mpi_irsend][]
- [ ] [mpi_wait][]
- [ ] [mpi_probe][]
- [ ] [mpi_iprobe][]
- [ ] [mpi_cancel][]


- [ ] [mpi_barrier][]


- [ ] [mpi_bcast][]
- [ ] [mpi_scatter][]
- [ ] [mpi_gather][]
- [x] [mpi_scatterv][]
- [x] [mpi_gatherv][]
- [ ] [mpi_alltoall][]
- [ ] [mpi_allgather][]
- [ ] [mpi_alltoallv][]
- [ ] [mpi_allgatherv][]


- [ ] [mpi_reduce][]
- [ ] [mpi_allreduce][]
- [ ] [mpi_reduce_scatter][]
- [ ] [mpi_scan][]

[mpi_hello_world]: ./MPI/src/mpi_helloworld.f90
[mpi_scatterv]: ./MPI/src/mpi_scatterv.f90
[mpi_gatherv]: ./MPI/src/mpi_scatterv.f90

## OpenMP

- [x] [[HELLO WORLD][openmp_hello_world]]
- [x] [do][omp_do]
- [ ] [for][]
- [ ] [sections][]
- [ ] [single][]
- [ ] [master][]
- [ ] [critical][]
- [ ] [atomic][]
- [ ] [barrier][]
- [ ] [flush][]
- [ ] [ordered][]

- [ ] [reduction][]


[openmp_hello_world]: ./OpenMP/src/openmp_helloworld.f90
[omp_do]: ./OpenMP/src/omp_do.f90

## MPI and OpenMP

- [x] [[HELLO WORLD][mpi_openmp_hello_world]]

[mpi_openmp_hello_world]: ./MPI_OpenMP/src/mpi_openmp_helloworld.f90
