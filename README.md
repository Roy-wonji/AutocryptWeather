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

## 📑 목차

- [🖥️ 개발환경](#🖥%EF%B8%8F-개발-환경)
- [🔑 핵심기술](#%F0%9F%94%91-핵심-기술)
- [🔭 프로젝트 구조](#🔭-프로젝트-모듈-구조)
- [📱 실행화면](#📱-실행화면)
- [🛠 트러블 슈팅](#🛠%EF%B8%8F-트러블-슈팅)

<br>

## 🖥️ 개발 환경

- Xcode 15
- Swift 5.10
- 의존성 관리: SPM

<br>

## 🔑 핵심 기술 

### 🗃️ 프레임워크
- UI: SwiftUI

### 🗂️ 외부 의존성
- 아키텍쳐 : MVVM,TCA
- 네트워킹 : Moya
- 모듈화 : Tuist
<br>


## 🛠️ 트러블 슈팅
### ⚠️ 검색어 입력에 따른 필터링
- 검색어 입력 시, 데이터 로딩데이터 흐름 변경
- 데이터 불러올때 검색어를 입력했을때는 전체 다 호출 그렇지 않을경우는 20개씩 끝어서 구현
- 컴바인을 사용해서 구현
<br>

## 🔭 프로젝트 모듈 구조
<img src="https://github.com/user-attachments/assets/9dafdacd-0161-4549-9f99-253b44689eef" width="400">

### 홈 화면
|메인화면|메인화면|검색화면|검색화면 후 홈 화면 |검색화면 후 홈 화면 |
|:---:|:---:|:---:|:---:|:---:|
|<img src="https://github.com/user-attachments/assets/9e3039e0-66b5-48ce-beb7-c7f012772a89" width="200">|<img src="https://github.com/user-attachments/assets/ff5afa69-7a4e-4bf9-96d7-22ac77624eb0" width="200">|<img src="https://github.com/user-attachments/assets/3def2e30-678e-4785-94df-b2639fef7291" width="200">|<img src="https://github.com/user-attachments/assets/2fa058f6-6705-46a5-ba95-a8d0270b8272" width="200">|<img src="https://github.com/user-attachments/assets/9ad07ec5-93f0-4046-8f72-10337a7bdd16" width="200">|

