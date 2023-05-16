# Shooting Coin

ShootingRole deployed to: 0xa78f62a91c7872dc3151529739e309cdf6aED887
ShootingCoinManager deployed to: 0xCDf246E0060c3B2A68C182b2898EBa02147F4b27
ShootingNFT deployed to: 0xe30809a17107765fdE4A2767D9cD3D7Ce0b23B0b
Test STC deployed to : 0x2B82C160Fc42fB1F9da067164c838b41f4D541cB

## abi

./abi/pretty/contracts에서 추출

## type

./typechain-types/contracts에서 추출

## 호출 function : 주로 coinManager과 상호작용

: 테스트 코드를 보면 플로우를 알 수 있음

- enterGame
  : account와 BetInfo(BetInfoStruct 참고),salt(랜덤값)를 입력
  => 돈 입금, 대기열 상태

- quitGame
  : account와 salt(enter에서 사용한 랜덤값) 입력
  => 돈 출금, 대기열에서 제외

- startGame(only Relayer)
  : 고유한 game id와 두 유저의 주소를 입력
  => 게임 시작

- settleGame(only Relayer)
  : game Id, 유저들 주소, 획득한 amount 입력
  => 정산
