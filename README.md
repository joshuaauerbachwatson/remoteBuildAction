# Revised source to certain Nimbella remote build actions

If you have an account in [Nimbella](https://nimbella.com) you can request to have actions pre-compiled in the runtime container in which they will run.  This is called _remote build_ and is described [here](https://docs.nimbella.com/building#remote-builds).

Remote build in each runtime uses an OpenWhisk action with the name `/nimbella/builder/build_<lang>_<version>`.  The code of these actions is public.  For example, to retrieve the code for the Swift 5.4 runtime you can use

```
nim action get /nimbella/builder/build_swift_5.4 --save
```

The result will be in `build_swift_5.4.swift`.  The suffix just reflects the runtime that the action belongs to.  It is not actually Swift code, rather Python code.

Many runtimes actually share the same build action code.  The code for Swift is also used for Go, Jave, Python, Php, and a few others.  This code is suitable for all _action-loop_ runtimes that are not also `nodejs`-based runtimes.  

The existing action works fine for running correct builds (those that will succeed).  But, there are a number of problems with error handling, meaning that, if there is some error in your code, you will find it hard to diagnose.  In the worst case, the action will hang after the error is caught, and will time out.  There is essentially no useful information about the original error in the activation record.

In this repository I am maintaining an alternate version of the builder action for action-loop runtimes that provides smooth feedback of error information when there are failures.  The output (currently) is a little too verbose:

```
 ›   Error: While deploying running remote build for test: Remote error ' ›   Error: 'swift:5.4' is not a valid runtime value
```

I will propose a small PR to the Nimbella deployer that will improve that wording to be less redundant.

To use this code

1.  Clone this repository locally.
2.  Then `nim project deploy /path/to/clone`
    - This will install copies of the action-loop builder actions in your personal namespace.
    - Any recent version of `nim` can be used to _install_ the actions.
3.  To _use_ the just-installed actions for remote builds, you need a version of `nim` more recent than 1.17.0 (which was the stable version as of this writing).
    - Install the _preview_ version of `nim` using `npm` or `yarn`, globally, from https://preview-apigcp.nimbella.io/nimbella-cli.tgz.
    - Or, build and locally install your own `nim` as described in the README in `https://github.com/nimbella/nimbella-cli`.
    - This will become unnecessary when a version later than 1.17.0 is released.
4.  Set `TEST_BUILDER_NAMESPACE` to your personal namespace in the environment.
    - This will cause the alternative builder actions to be used for remote builds in action-loop runtimes.
    - For remote builds in `nodejs` runtimes you will need to unset the environment variable or set it to `nimbella` because I don't provide alternatives for those. 
