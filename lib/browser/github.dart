import 'package:dcli/dcli.dart';
import 'package:puppeteer/puppeteer.dart';

class GithubAutomate {
  Future<void> createRepo(String name, bool isPublic) async {
    var username =
        ask(green('Your Username: '), defaultValue: 'braveboy2058@gmail.com');
    var password =
        ask(green('Your Password: '), hidden: true, validator: Ask.required);
    var browser = await puppeteer.launch(headless: false);
    var newPage = await browser.newPage();
    print(orange('Performing Login'));
    await newPage.goto('https://github.com/login', wait: Until.networkIdle);

    // Select name field

    var nameselector = '#login_field';
    await newPage.waitForSelector(nameselector);
    await newPage.click(nameselector);
    await newPage.type(nameselector, username);

    var passwordselector = '#password';
    await newPage.waitForSelector(passwordselector);
    await newPage.click(passwordselector);
    await newPage.type(passwordselector, password);

    var buttonselector =
        '#login > div.auth-form-body.mt-3 > form > input.btn.btn-primary.btn-block';

    await newPage.clickAndWaitForNavigation(buttonselector);
    print(orange('Creating Repository'));
    await newPage.goto('https://github.com/new', wait: Until.networkIdle);

    // Selectors
    var public = '#repository_visibility_public';
    var private = '#repository_visibility_private';
    var createButton = 'button.first-in-line:not([disabled])';

    if (await fillname(name, newPage)) {
      print(green('Name Validated'));
      await newPage.waitForSelector(public);
      await newPage.waitForSelector(private);

      if (!isPublic) {
        await newPage.click(private);
      } else {
        await newPage.click(public);
      }

      await newPage.clickAndWaitForNavigation(createButton);

      print(orange('\nSuccessfully Created a Repo\n'));
      print(orange('Repo url: ' + newPage.url));

      await browser.close();
    }
  }

  Future<bool> fillname(String name, Page newPage) async {
    var reponame = '#repository_name';
    await newPage.waitForSelector(reponame);
    await newPage.click(reponame);
    await newPage.keyboard.down(Key.control);
    await newPage.keyboard.press(Key.keyA);
    await newPage.keyboard.up(Key.control);
    await newPage.keyboard.press(Key.backspace);
    await newPage.type(reponame, name);

    try {
      await newPage.waitForSelector('button.first-in-line:not([disabled])',
          timeout: Duration(seconds: 3));
      return true;
    } catch (e) {
      printerr(red('Error: Name of the repository is not valid!'));
      name = ask(green('New Name: '), validator: Ask.required);
      return await fillname(name, newPage);
    }
  }
}
