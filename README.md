# "Has Changes" Docker Action

This action sets a boolean output (`has_changes`) if the diff (`push` or
`pull_request` event) includes matching changes. Users can provide a list of
paths that should be considered / included, as well as a list of paths that
should be ignored / excluded.

### How does this relate to native `paths` / `paths-ignore` support in Github Actions?

When configuring
[paths](https://docs.github.com/en/actions/using-workflows/workflow-syntax-for-github-actions#onpushpull_requestpull_request_targetpathspaths-ignore)
natively in Github Action, the worfklow will not run at all if all changes
should be ignored. In turn, this means that no successful status will be
reported for the workflow. This is not acceptable if you use protected branches,
and pull requests can only be merged once all worfklows report a successful
status. This is why this Github Action was created.

## Inputs

* An optional list of paths to include. By default, all paths will be included.
* An optional list of paths to exclude. By default, no path will be excluded.

The action will use Bash pattern matching, so wildcards (`*`) are supported.

## Outputs

### `has_changes`

Whether ('yes' or 'no') the diff includes changes outside of the provided list
of paths.

## Example usage

```yaml
jobs:
  has-changes:
    runs-on: ubuntu-latest
    steps:
    - name: Checkout repo
      uses: actions/checkout@v3
      with:
        # fetch all history for all branches and tags (this is required for the has-changes action)
        fetch-depth: 0
    - name: Run action
      uses: antrea-io/has-changes@v2
      id: run_action
      with:
        paths-ignore: docs *.md ci
    outputs:
      has_changes: ${{ steps.run_action.outputs.has_changes }}
```
