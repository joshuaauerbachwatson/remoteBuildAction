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

The code is currently structured for easy installation as a Swift 5.4 builder action only.  I will change that, and provide instructions on how you can install the action for any of the runtimes to which it applies and temporarily use that alternative.
