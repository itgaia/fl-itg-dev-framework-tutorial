# ITG Development Framework Tutorial app

We want to set the foundations for a development framework that will give us the ability
to build more than one applications that will all share some common characteristics.

In this tutorial series we will build, step by step, a fully working app and 
the first stable version of the a development framework having the following 
characteristics in mind:
- Keep up-to-date. As we build more apps, the framework will evolve/change and each of the apps will be able to upgrade and use the latest framework version with the least possible effort.
- Modularisation. Each app will build with the modular approach. Each module will be pluggable to different apps and customisable in order to support different similar business cases.
- Code re-use. Build the app code and the test code with the "Don't repeat yourself" (DRY) principle. DRY is a software development principle which aims to reduce the repetition of code. It uses abstractions or data normalisation in order to avoid redundancy.
- Cross Platform. It will run in mobiles, touchpads, pcs, notebooks. We will use Flutter for the development of the app and we will support iOS, Android and Web interface.
- Testing. It will be developed following the Test Driven Development principles (TDD) and we intent to reach as much as possible the 100% test code coverage.
- Scalable. It will be fully scalable. Nice and clean structure, easy for the new developers in our team to understand and work with it.
- Environments. It will support the basic environments (development, testing, staging, production) and also any other custom environment.
- State Management. We will use Bloc for State Management.
- Logging. It will have full logging support. We will monitoring for any errors or special conditions and notify for them through specific channels (email, messenger, discord, sms, etc).
- Multi-user. It will support one or more users, belonging in one or more User Groups / Organisations.
- Security. It will give the user the option to categorise the data as personal, shared among specific users or groups/organisations or fully public.
- Internationalisation. It will support different languages and the ability to change the language ad-hoc.
- Customisation. Each user / user group / organisation will be able to customise the basic aspects of the app (theme data, language, landing page, etc)

More info for this app you can see in [ITG Development Framework Tutorial](http://apgortsilas.aggate.gr/development-framework-tutorial-series-build-a-full-working-app-with-flutter-and-clean-architecture-introduction)

based on:
* flutter-tdd-clean-architecture-course (Resocoder)
* https://bloclibrary.dev/#/fluttertodostutorial?id=edittodo (felangel, bloc)
* Getting Started With Flutter BLoC
  https://www.netguru.com/blog/flutter-bloc
  Kacper Kogut - Nov 12, 2019
* All About JSON Serialization in Flutter Tutorial (Resocoder)
  Starter project from the [Flutter Education Membership](https://resocoder.com/fem).
  https://resocoder.academy/courses/flutter-education-membership/lectures/35901691
* Firebase Auth with Riverpod (Flutter tutorial by Resocoder)
  https://resocoder.academy/courses/enrolled/1563905
  https://github.com/ResoCoder/firebase-auth-with-riverpod-tutorial
* testing-flutter-apps-tutorial
* flutter_tdd_notes_app
* yatl
* https://fredgrott.medium.com/missing-flutter-test-best-practices-b7c651884da5
* https://medium.com/geekculture/missing-flutter-best-practices-72a1fa684d09
* https://codelabs.developers.google.com/codelabs/flutter-app-testing#0
* https://blog.gskinner.com/archives/2021/11/flutter-deep-dive-into-the-new-skeleton-app-template.html
* https://medium.com/@artemosipov/ultimate-guide-of-how-to-test-in-flutter-7b3cd4509b56
* https://moduscreate.com/blog/introduction-to-flutter-widget-testing/

## History

04/03/2022: Initial creation of project based on Flutter app template with a simple home page\
15/03/2022: Added the feature Notes with testing\
