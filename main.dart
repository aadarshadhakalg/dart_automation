#! /usr/bin/env dcli

import 'dart:io';
import 'package:dcli/dcli.dart';
import 'lib/browser/github.dart';

void main(List<String> args) {
  final parser = ArgParser();
  print(orange('Welcome to Automate!'));

  var selection = menu(
      prompt: orange('Select what you want to automate: '),
      options: ['Create Github Repository', 'Exit']);

  if (selection == 'Exit') {
    print(green('Thank You for using automate'));
    exit(0);
  }

  if (selection == 'Create Github Repository') {
    var name = ask(green('Repository Name: '), defaultValue: 'hello');
    var public = confirm(green('Is your repository public?'));
    GithubAutomate().createRepo(name, public);
  }
}
