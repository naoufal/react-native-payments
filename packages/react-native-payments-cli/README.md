# react-native-payments-cli

## Installation
First, install [Carthage](https://github.com/Carthage/Carthage) (if you don't already have it installed):

```bash
$ brew install carthage
```

Second, install the package:

```bash
$ yarn add react-native-payments-cli
```

## Commands
### list
Outputs a list of installed add-ons that can be linked.

#### Example
```bash
$ react-native-payments-cli list
```
---

### link
Links an add-ons native dependencies to your project.

#### Example
```bash
$ react-native-payments-cli link stripe
```
