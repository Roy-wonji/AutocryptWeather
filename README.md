# AutocryptWeather
Autocrypt iOS 과제

## Tuist Usage
1. Install tuist
 
```swift
curl -Ls https://install.tuist.io | bash 
```
2. Generate project

```swift
tuist clean // optional
make install // optional
make generate
```

## 기술 스택 
- iOS  
  <img src="https://img.shields.io/badge/fastlane-00F200?style=for-the-badge&logo=fastlane&logoColor=white">
  <img src="https://img.shields.io/badge/swift-F05138?style=for-the-badge&logo=swift&logoColor=white">
  <img src="https://img.shields.io/badge/xcode-147EFB?style=for-the-badge&logo=xcode&logoColor=white"> 

## 🐈‍⬛ Git

### 1️⃣ Git branching Strategy

- Origin(main branch)
- Origin(dev branch)
- Local(feature branch)

- Branch
- Main
- Dev
- Feature
- Fix

- 방법
- 1. Pull the **Dev** branch of the Origin
- 2. Make a **Feature** branch in the Local area
- 3. Developed by **Feature** branch
- 4. Push the **Feature** from Local to Origin
- 5. Send a pull request from the origin's **Feature** to the Origin's **Dev**
- 6. In Origin **Dev**, resolve conflict and merge
- 7. Fetch and rebase Origin **Dev** from Local **Dev**
