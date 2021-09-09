# Revised source to certain Nimbella remote build actions

If you have an account in [Nimbella](https://nimbella.com) you can request to have actions pre-compiled in the runtime container in which they will run.  This is called _remote build_ and is described [here](https://docs.nimbella.com/building#remote-builds).

Remote build in each runtime uses an OpenWhisk action with the name `/nimbella/builder/build_<lang>_<version>`.  The code of these actions is public.  For example, to retrieve the code for the Swift 5.4 runtime you can use
```
nim action get /nimbella/builder/build_swift_5.4 --save
```
The result will be in `build_swift_5.4.swift`.  The suffix just reflects the runtime that the action belongs to.  It is not actually Swift code, rather Python code.

Many runtimes actually share the same build action code.  The code for Swift is also used for Go, Jave, Python, Php, and a few others.  This code is suitable for all _action-loop_ runtimes that are not also `nodejs`-based runtimes.  

The existing action works fine for running correct builds (those that will succeed).  But, there are a number of problems with error handling, meaning that, if there is some error in your code, you will find it hard to diagnose.   

In this repository I am maintaining an alternate version of the builder action for action-loop runtimes that provides smooth feedback of error information when there are failures.  It cooperates with a small change to `nim` CLI in order to achieve the proper error display.

There is no easy way for me to submit a PR for this code because, although it is made public in the published actions, it is not sourced from a public repository.  But
1.  The code shown here started with an exact copy made with `nim action get` as shown above.
2.  As you can see the, code is under the Apache License.
3.  By putting my revised version in this repository I am donating the result back to Nimbella and will work with Nimbella personnel on getting it integrated.
