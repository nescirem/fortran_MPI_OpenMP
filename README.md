# Coding with MPI and OpenMP

Tests of hybrid parallel programming with Fortran on Windows platform. [[中文版](./README_cn.md)]



## Installations

- OS: Windows 10
- IDE: Visual Studio 2017
- Compeller: Intel Visual Fortran 2019
- Software: MPICH2


# Example codes

## MPI

- [x] [[HELLO WORLD][mpi_hello_world]]
- [x] [mpi_send][]
- [x] [mpi_recv][]
- [ ] [mpi_sendrecv]
- [ ] [mpi_bsend]
- [ ] [mpi_ssend]
- [ ] [mpi_rsend]
- [ ] [mpi_isend]
- [ ] [mpi_ibsend]
- [ ] [mpi_issend]
- [ ] [mpi_irsend]
- [ ] [mpi_wait]
- [ ] [mpi_probe]
- [ ] [mpi_iprobe]
- [ ] [mpi_cancel]


- [x] [mpi_barrier][]


- [x] [mpi_bcast][]
- [ ] [mpi_scatter]
- [x] [mpi_gather][]
- [x] [mpi_scatterv][]
- [x] [mpi_gatherv][]
- [ ] [mpi_alltoall]
- [ ] [mpi_allgather]
- [ ] [mpi_alltoallv]
- [ ] [mpi_allgatherv]


- [ ] [mpi_reduce]
- [ ] [mpi_allreduce]
- [ ] [mpi_reduce_scatter]
- [ ] [mpi_scan]

[mpi_hello_world]: ./MPI/src/mpi_helloworld.f90
[mpi_send]: ./MPI/src/mpi_send.f90
[mpi_recv]: ./MPI/src/mpi_send.f90
[mpi_barrier]: ./MPI/src/test_all_mpi.f90
[mpi_bcast]: ./MPI/src/mpi_send.f90
[mpi_gather]: ./MPI/src/mpi_send.f90
[mpi_scatterv]: ./MPI/src/mpi_scatterv.f90
[mpi_gatherv]: ./MPI/src/mpi_scatterv.f90

## OpenMP

- [x] [[HELLO WORLD][omp_hello_world]]
- [x] [do][omp_do]
- [ ] [for]
- [ ] [sections]
- [ ] [single]
- [ ] [master]
- [ ] [critical]
- [ ] [atomic]
- [ ] [barrier]
- [ ] [flush]
- [ ] [ordered]

- [ ] [reduction]


[omp_hello_world]: ./OpenMP/src/omp_helloworld.f90
[omp_do]: ./OpenMP/src/omp_do.f90

## MPI and OpenMP

- [x] [[HELLO WORLD][mpi_omp_hello_world]]

[mpi_omp_hello_world]: ./MPI_OpenMP/src/mpi_omp_helloworld.f90
