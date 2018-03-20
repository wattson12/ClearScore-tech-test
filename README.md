# ClearScore-tech-test

## Build Environment

Built using Xcode 9.2, dependencies fetched with Cocoapods 1.4.0

Pod directory included, and Podfile.lock contains specific versions

## Dependencies

RxSwift & RxCocoa for bindings. The architecture is MVVM-C which is a lot simpler with bindings, and since we discussed Rx in the phone interview it made sense to include it. 

SwiftLint is there to give some warnings. Main config change is to increase the maximum size of lines since UIKit can get a bit verbose 

## Testing

Unit tests covering the view model, mapping, mapping helpers and a few other small parts 

UI tests covering some simple checks that text / activity indicator exists. The setup for each scenario is done via launch arguments. This is a pretty rough way of doing this since its hard to be dynamic but it does the job for getting something up and running quickly. 

## Other stuff

Not all of the UI is done to match the design, though the components and layout are there (e.g. nav bar colour)

The gradient view is using a CAGradientLayer and animated `strokeEnd`. Since this is a linear gradient it looks strange when the score is > 50% of the total (the random colours dont help). I thought about using 2 gradient layers side by side with a set of colours that match one one half to get a fake radial effect but didnt have time. 

Strings are localised. I wanted to use something like SwiftGen to convert the stringly typed code to types but didnt have time. 
