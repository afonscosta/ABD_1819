#! /bin/bash
time pg_dump -h localhost -Fc tpcc-db > tpcc.dump
