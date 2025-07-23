## [🔥] Ignitor
![Logo](https://github.com/4uzhoy/ignitor/blob/main/doc/logo.jpg)

Ignitor is a Flutter project template with predefined structure and tooling, built for projects where key architectural choices are already made.
It’s not a flexible starter for every use case — instead, it reflects an opinionated setup meant to streamline the early stages of development.

## 🧱 Template

This template is built on top of [sizzle_starter](https://github.com/hawkkiller/sizzle_starter) by Michael Lazebny — immense thanks to him for the original foundation.
Unlike sizzle_starter, this version is less flexible and less actively maintained, as it reflects a personal opinionated structure rather than a generalized starter.

Additionally, the template integrates several packages from the [PlugFox](https://plugfox.dev/packages/) ecosystem, which offer high-quality, modular tools tailored for production-level Flutter development.

## Purpose
The goal of this template is not to serve as a neutral entry point for all Flutter apps, but rather as a ready-made, structured foundation that assumes certain architectural decisions have already been made.

It aims to reduce friction at project start, offering preconfigured tools, folder structure, and separation of concerns that streamline the development workflow.

## Notes
* The domain package is extracted into a separate Dart package. This is not a hard rule, just a conscious decision in favor of decoupling models, contracts, and core logic from the rest of the app. You may follow this or not — depends on your context.

The template enforces a clear separation:
Features
Common components
Shared tools
Widget-level isolation

`Nothing here claims to be universally correct. It’s just a system that works well when you accept the constraints — or adjust them to your own.`