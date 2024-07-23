# Workflow Tests

These tests verify that workflows (from `/inst/workflow/`) are working as expected.
The intention of these tests is to more exhaustively confirm that changes did not break standard processes in unexpected ways.

These tests are performed each time a pull request is merged into the `dev` branch, but do not block such merges.

The tests confirm the following:

- All data passed into the workflow is returned (when specified to do so).
- Workflows return data with exactly the expected names.
- All data returned by workflows is non-empty.
