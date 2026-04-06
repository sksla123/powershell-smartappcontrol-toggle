# 🛡️ Windows Smart App Control (SAC) Toggle Tool

Windows 11의 **Smart App Control(SAC)** 정책으로 인해 개발 도구(gcc, g++, jupyter, scoop, uv 등)가 예기치 않게 차단되는 문제를 해결하기 위한 자동화 스크립트입니다.

> **[!CAUTION]**
>
> **스크립트 실행 전, 하단의 [⚠️ 주의사항 및 면책 조항](#️-주의사항-및-면책-조항-disclaimer) 내용을 반드시 숙지하시기 바랍니다. 본 도구 사용으로 인한 시스템 설정 변경 및 결과에 대한 책임은 사용자 본인에게 있습니다.**
> 
> **Please read the [⚠️ Disclaimer](#️-주의사항-및-면책-조항-disclaimer) section at the bottom carefully before running the script. If you are not fluent in Korean, please use a translator to ensure you fully understand the terms. You are solely responsible for any system configuration changes or consequences resulting from the use of this tool.**

## 📋 개요
Smart App Control은 AI 기반의 보안 기능이지만, 서명되지 않은 바이너리나 로컬 컴파일러를 빈번하게 사용하는 개발 환경에서는 심각한 워크플로우 저해를 초래합니다. 본 도구는 레지스트리 값을 직접 수정하여 SAC 상태를 신속하게 전환(Toggle)할 수 있도록 돕습니다.

## 🚫 주요 차단 사례 (Issue Logs)
Smart App Control(SAC)에 의해 가장 빈번하게 오탐(False Positive)으로 차단되는 도구 및 시나리오입니다:

* **Compilers**: `gcc.exe`, `g++.exe`, `rustc` 등 (로컬 환경에서 생성된 바이너리 실행 차단)
* **Runtime/Shell**: `Jupyter Notebook`, `Python` 가상환경(venv) 내의 핵심 실행 파일
* **Package Managers**: `Scoop`, `uv`, `Cargo` 등 사용자 로컬 경로(AppData 등)에 설치되는 도구
* **Scripts**: 정식 디지털 서명이 없는 사용자 제작 `.ps1`, `.bat`, `.sh` 파일
* **개발 결과물 (Build Artifacts)**: 
    * **직접 빌드한 `.exe` 파일**: 소스 코드를 수정하고 새로 빌드할 때마다 "출처를 알 수 없는 앱"으로 간주되어 즉시 실행이 차단됨
    * **테스트용 바이너리**: CI/CD 과정 없이 로컬에서 테스트 목적으로 생성된 모든 실행 파일
    * **임시 라이브러리**: 동적 링크 라이브러리(`.dll`) 로드 시 보안 정책 위반으로 인한 런타임 오류 발생

## 🛠️ 주요 기능
1. **실시간 상태 확인**: 현재 시스템의 SAC 활성화 여부를 즉시 조회합니다.
2. **레지스트리 직접 제어**: `HKLM` 내 `VerifiedAndReputablePolicyState` 값을 0/1로 수정합니다.
3. **접근성 최적화**: 시작 메뉴 바로가기 생성 및 관리자 권한 자동 실행 기능을 제공합니다.

## 🚀 사용 방법

### 1. 초기 설정 (Shortcut Setup)
먼저 시작 메뉴에 실행 아이콘을 등록합니다.
* `add_to_startmenu.ps1` 파일을 마우스 우클릭 후 **[PowerShell에서 실행]**을 선택합니다.
* 시작 메뉴에 **노란색 방패 아이콘(⚠️)**의 `Toggle Smart App Control` 항목이 생성됩니다.

### 2. 정책 전환 (Toggling)
1. 시작 메뉴에서 생성된 바로가기를 클릭합니다.
2. 현재 상태가 출력되면 전환 여부를 묻는 프롬프트에서 **`Y`**를 입력합니다.
3. **[중요]** 레지스트리 수정 후 시스템에 정책을 완전히 반영하려면 **재부팅**이 권장됩니다.

## 📂 파일 구조
* `toggle_SAC.ps1`: 상태 확인 및 레지스트리 수정을 담당하는 메인 로직
* `add_to_startmenu.ps1`: 시작 메뉴 바로가기 생성 및 아이콘(imageres.dll, 79) 설정 스크립트


## ⚠️ 주의사항 및 면책 조항 (Disclaimer)

**본 스크립트를 사용하기 전에 아래 내용을 반드시 숙지하십시오.**

1. **사용자 책임 및 면책**: 본 스크립트는 시스템의 핵심 영역인 레지스트리를 직접 수정합니다. **이 파일의 실행으로 인해 발생하는 시스템 오류, 데이터 손실, 보안 취약점 노출 등 모든 결과에 대한 책임은 전적으로 실행한 사용자 본인에게 있습니다.** 제작자는 본 도구의 사용으로 인해 발생하는 어떠한 직간접적인 피해에 대해서도 법적·도의적 책임을 지지 않습니다.

2. **복구 관련 불확실성**: 레지스트리 수정을 통해 설정값을 다시 되돌리는 시도는 가능하나, 이것이 Microsoft가 권장하는 **정상적인 서비스 상태(평가 모드 등)로 완벽하게 복구되는 것인지에 대해서는 보장할 수 없습니다.** 시스템 환경에 따라 정책이 비정상적으로 고착될 수 있습니다.

3. **시스템 재설치 가능성**: Microsoft의 공식 가이드에 따르면, Smart App Control을 한 번 '해제' 상태로 변경한 후 다시 완전한 '평가' 또는 '켜짐' 상태로 되돌리기 위해서는 **Windows의 초기화 또는 재설치**가 필요할 수 있습니다. (출처: [Microsoft Support](https://support.microsoft.com/windows/what-is-smart-app-control-285ea03d-fa88-4d56-882e-66f6213077fa))

4. **보안 수준 변경**: 이 기능을 끄면 시스템의 보안 수준이 낮아져 서명되지 않은 위험한 파일이 실행될 수 있습니다. 모든 실행 파일의 안전성 판단은 사용자의 몫입니다.

5. **백업 권장**: 레지스트리 수정 전, 만약의 사태를 대비해 중요한 데이터와 시스템 복원 지점을 생성해 두는 것을 강력히 권장합니다.
