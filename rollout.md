## Rollout plan

This document describes the steps to roll out pending changes to the builder actions, the Swift runtime, the `nim` CLI, and the Swift SDK.

The changes are in

- **this repo** for the builder actions (not a PR; intended to replace the actions currently used for action-loop runtimes that support remote build);
- **https://github.com/nimbella-corp/openwhisk-runtime-swift/pull/5** for changes to the Swift runtime;
- **https://github.com/nimbella/nimbella-deployer/pull/23** for the `nim` CLI changes.  There are also several important older changes that are merged but not yet in a stable version.  A stable version is a pre-req for rebuilding the runtimes;
- **https://github.com/nimbella/nimbella-sdk-swift/pull/3** for the Swift SDK changes to make it operational and useful.

The changes are interdependent and all are required (the actual CLI change in this PR is optional but a new CLI version is required due to other changes in the pipeline).

### Steps

1.  Review the code in this repo and adopt the changes into the internal repo for the production builder actions.  Relevant files are

 - https://github.com/joshuaauerbachwatson/remoteBuildAction/blob/main/code/builder-action.py (required)
 - 

