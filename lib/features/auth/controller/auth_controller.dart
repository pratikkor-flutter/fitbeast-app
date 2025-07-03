import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitbeast/core/constants/app_constants.dart';
import 'package:fitbeast/core/utils/custom_snackbar.dart';
import 'package:fitbeast/core/utils/validations.dart';
import 'package:fitbeast/repository/user_repository.dart';
import 'package:fitbeast/routes/app_routes.dart';
import 'package:fitbeast/services/local_storage_get/local_storage_get.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final GetStorage _storage = GetStorage();

  // Controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final usernameController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // States
  RxBool showPassword = false.obs;
  RxBool isLoading = false.obs;
  RxString emailError = RxString('');
  RxString passwordError = RxString('');
  RxString nameError = RxString('');
  RxString usernameError = RxString('');
  RxString confirmPasswordError = RxString('');
  RxString termsError = RxString('');
  RxBool acceptTerms = false.obs;
  RxBool showConfirmPassword = false.obs;

  void toggleConfirmPasswordVisibility() => showConfirmPassword.toggle();

  void togglePasswordVisibility() => showPassword.toggle();

  Future<void> login() async {
    try {
      // validate the text fields
      if (!await validateInputs()) return;

      isLoading.value = true;

      // Firebase Login
      final currentLoginUser = await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (currentLoginUser.user != null) {
        showFitSnackbar('Login successful!');

        // update login status in get storage
        await LocalStorageGet().setUserLoggedInStatus(true);

        final bool postRegOnboardingComplete =
            _storage.read(LocalStorageKeys.postRegOnboardingKey) ?? false;

        // update user fetched from firebase and set in local storage
        final user = await UserRepository()
            .getUserFromFirebase(currentLoginUser.user!.uid);
        if (user != null) {
          await LocalStorageGet().setName([user.name, user.username]);
          await UserRepository().setUserInHive(user);
        }

        if (postRegOnboardingComplete) {
          Get.offAllNamed(Routes.appShell);
        } else {
          Get.offAllNamed(Routes.postReg);
        }
      }
    } on FirebaseAuthException catch (e) {
      _handleAuthError(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> validateInputs({bool isLogin = true}) async {
    nameError.value = '';
    usernameError.value = '';
    emailError.value = '';
    passwordError.value = '';
    confirmPasswordError.value = '';
    termsError.value = '';

    if (!isLogin) {
      if (nameController.text.isEmpty) {
        nameError.value = 'Name is required';
        return false;
      }
    }

    if (!isLogin) {
      if (usernameController.text.isEmpty) {
        usernameError.value = 'Username is required';
        return false;
      }
    }

    if (emailController.text.isEmpty) {
      emailError.value = 'Email is required';
      return false;
    }

    if (!await isValidEmail(emailController.text)) {
      emailError.value = 'Enter a valid email';
      return false;
    }

    if (passwordController.text.isEmpty) {
      passwordError.value = 'Password is required';
      return false;
    }

    if (!isValidPassword(passwordController.text)) {
      passwordError.value = 'Password needs [8+ chars, A-Z, a-z, 0-9, !@#%^&*]';
      return false;
    }

    if (!isLogin) {
      if (confirmPasswordController.text.isEmpty) {
        confirmPasswordError.value = 'Password is required';
        return false;
      }

      if (confirmPasswordController.text != passwordController.text) {
        confirmPasswordError.value = 'Passwords don\'t match';
        return false;
      }

      if (!acceptTerms.value) {
        termsError.value = 'Accept terms to continue';
        return false;
      }
    }

    return true;
  }

  Future<void> signInWithGoogle() async {
    try {
      isLoading.value = true;
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final user = await _auth.signInWithCredential(credential);

      log('LOGIN FAILED - ${user.toString()}');

      showFitSnackbar('Google login successful!');

      // update login status in get storage
      await LocalStorageGet().setUserLoggedInStatus(true);

      final bool postRegOnboardingComplete =
          _storage.read(LocalStorageKeys.postRegOnboardingKey) ?? false;
      if (postRegOnboardingComplete) {
        Get.offAllNamed(Routes.appShell);
      } else {
        Get.offAllNamed(Routes.postReg);
      }
    } on FirebaseAuthException catch (e) {
      log('EXCEPTION - ${e.toString()}');
      _handleAuthError(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signInWithInstagram() async {
    // Implement Instagram auth
    // (Requires Firebase setup & Instagram Developer account)
  }

  Future<void> signInWithTwitter() async {
    // Implement Twitter auth
    // (Requires Firebase setup & Twitter Developer account)
  }

  void _handleAuthError(FirebaseAuthException e) {
    log(e.toString());
    String message = 'Login failed';
    switch (e.code) {
      case 'user-not-found' || 'invalid-credential':
        message = 'No user found with this email';
        break;
      case 'wrong-password':
        message = 'Incorrect password. Try again';
        break;
      case 'too-many-requests':
        message = 'Too many attempts. Try again later';
        break;
    }
    showFitSnackbar(message, isError: true);
  }

  Future<void> register() async {
    try {
      // validate the text fields
      if (!await validateInputs(isLogin: false)) return;

      isLoading.value = true;

      // Create user in Firebase
      await _auth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // Update user profile
      await _auth.currentUser?.updateDisplayName(nameController.text.trim());
      // update user in get storage
      // list of name & username value
      LocalStorageGet().setName([
        nameController.text.trim(),
        usernameController.text.trim(),
      ]);

      // update user in firebase
      await FirebaseFirestore.instance
          .collection('users')
          .doc(_auth.currentUser?.uid)
          .set({
        'uid': _auth.currentUser?.uid,
        'name': nameController.text.trim(),
        'username': usernameController.text.trim(),
        'email': emailController.text.trim(),
      }, SetOptions(merge: true));

      // TODO: if email is needed, do edit this code
      // also need to develop a screen which accepts email verification status

      // Send verification email
      // await _auth.currentUser?.sendEmailVerification();

      // showFitSnackbar('Account created! Please verify your email');
      // Get.offAllNamed('/email-verification');

      clearRegisterController();
      Get.back();
    } on FirebaseAuthException catch (e, st) {
      log('$e, $st');
      _handleAuthError(e);
    } finally {
      isLoading.value = false;
    }
  }

  void clearLoginController() {
    emailController.clear();
    passwordController.clear();

    emailError.value = '';
    passwordError.value = '';
  }

  void clearRegisterController() {
    emailController.clear();
    passwordController.clear();
    nameController.clear();
    confirmPasswordController.clear();

    emailError.value = '';
    passwordError.value = '';
    nameError.value = '';
    usernameError.value = '';
    confirmPasswordError.value = '';
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    usernameController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
