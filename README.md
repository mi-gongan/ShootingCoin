# Shooting Coin

ShootingRole deployed to: 0xaA34dA0C9fFdB0D1B015fd02B451eA2377eB863B
ShootingCoinManager deployed to: 0x2149858836b33B629aB54Ded8468F3C6D5907018
ShootingNFT deployed to: 0x56003f01b0227329A47F4b2AEB91BEE7c95F594F
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
