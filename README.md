# auto_exec_tools 사용법

이 프로젝트는 사이버캠퍼스에서 다운로드한 과제 제출물을 자동으로 처리, 컴파일, 테스트하기 위한 도구 모음입니다.  
특히 `{학번}_{챕터번호}_{문제번호}.c` 형식의 제출이 요구되는 과제에 맞춰 설계되어 있습니다.
명령어는 모두 ubuntu 환경에서 사용하는 명령어로 제작했습니다.

---

## 1. 일괄 다운로드한 파일 압축 해제

사이버캠퍼스에서 받은 zip 파일은 cp949 인코딩으로 압축되어 있습니다. 다음 명령어로 압축을 해제합니다:

```bash
unzip -O cp949 [zip_file] -d [output_dir]
```

---

## 2. auto_exec_tools 폴더 복사

압축 해제된 폴더 내부로 `auto_exec_tools/` 디렉토리를 복사합니다:

```bash
cp -r auto_exec_tools [output_dir]
```

---

## 3. 파일명 정리

auto_exec_tools 디렉토리로 이동하여 `name_change.py`를 실행합니다:

```bash
cd [output_dir]/auto_exec_tools
./name_change.py
```

- 사이버캠퍼스 다운로드 시 자동으로 변경된 파일명을 `{학번}_{챕터번호}_{문제번호}.c` 형식으로 재정리합니다.
- 형식이 잘못된 파일은 무시됩니다.

---

## 4. 전체 코드 컴파일

다음 명령어를 실행하여 auto_exec_tools의 상위 디렉토리(`..`)에 있는 모든 `.c` 파일을 컴파일합니다:

```bash
make
```

- 컴파일 성공: `../success/` 디렉토리에 실행파일 생성
- 컴파일 실패: `fail_compile.txt` 파일에 실패한 파일명 기록


```bash
make clean
```

- `../success/`, `fail_compile.txt`, `../outputs/` 디렉토리 및 파일 삭제

---

## 5. 실행 및 테스트

`auto_exec_tools` 디렉토리에 `input_{n}.txt` 형식으로 입력파일을 생성한 뒤, 다음 명령어를 사용해 테스트합니다:

```bash
./auto_exec.sh ../success/{exec_file} {input_num} {time_limit}
```

예시) ch07의 1번 문제를 3개의 input과, 0.5초 시간제한으로 채점한다면:

```bash
./auto_exec.sh ../success/*_07_01 3 0.5
```

- 실행파일이 `_07_01`로 끝나는 모든 파일에 대해
- `input_1.txt`, `input_2.txt`, `input_3.txt`를 입력으로 사용하여 실행
- 실행시간이 0.5초를 초과하면 오류로 간주

실행 결과:

- 출력 파일: `../outputs/{exec_file}_{input_number}.out`
- 시간 초과: `../outputs/timeouts.txt`
- 런타임 에러: `../outputs/errors.txt`

