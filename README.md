# airbnb✈️

숙박 예약 앱 `airbnb` 클론 프로젝트



## iPhone11 구동 화면

<img src="https://user-images.githubusercontent.com/72188416/120914487-78b0fd00-c6d9-11eb-8dd6-a1353c8698ab.gif" alt="앱의 전반적인 흐름" width=320 align=left />



## 주요 구현 내용

<img src="https://user-images.githubusercontent.com/72188416/120915142-0e01c080-c6dd-11eb-8909-2df26004aaa0.png" alt="search" width=240 align=left  />



- **검색 화면**
  - `UISearchController` / `UISearchResultsUpdating` 활용
  - mock networking 객체를 통한 가짜 검색 데이터 제공



<img src="https://user-images.githubusercontent.com/72188416/120914492-7f3f7480-c6d9-11eb-952f-74868818570b.png" alt="calendar" width=240 align=left />



- **달력 선택 화면**

  - `UICollectionView`를 활용한 Custom Calendar UI 구현
  - Foundation의 [Calendar](https://developer.apple.com/documentation/foundation/calendar)를 활용하여 Custom Calendar Model 구현

  

<img src="https://user-images.githubusercontent.com/72188416/120914496-85355580-c6d9-11eb-8485-e973ab332ba2.png" alt="graph2" width=240 align=left  />



- **가격 선택 화면**
  - `CAShapeLayer`와 `UIBezierPath`를 활용한 Graph View 구현
  - mock API 데이터를 사용하여 가격 그래프 생성
  - [MultiSlider](https://github.com/yonat/MultiSlider) 라이브러리를 사용하여 2 thumbs slider 추가
  - `CALayer`의 `compositingFilter`를 활용하여 선택 영역 음영 추가



<img src="https://user-images.githubusercontent.com/72188416/120915138-0c37fd00-c6dd-11eb-962a-1481658cc81e.png" alt="list" width=240 align=left />



- **숙박 리스트 화면**
  - 날짜, 가격 선택에 따라 숙박 리스트 query
  - API 미구현에 따라 앱 내 가격 filter 후 데이터 노출





## 디테일 

### 사용자 편의 증대



<img src="https://user-images.githubusercontent.com/72188416/120915134-06421c00-c6dd-11eb-9ccc-095e46ad7029.png" alt="2022" width=240 align=left  />



- **캘린더**
  - 현재와 다른 연도의 날짜 선택 시 연도 표시
  - 같은 연도일 경우 일/월만 표시하도록 구현



<img src="https://user-images.githubusercontent.com/72188416/120915140-0d692a00-c6dd-11eb-9e10-8c0f204646dc.png" alt="shimmer" width=240 align=left  />

- **숙소 리스트 화면**
  - 네트워크 데이터 표시 전 스켈레톤 UI 표시
  - `CAGradientLayer`와 `CAAnimation`을 활용하여 Shimmer 생성, 적용



### 에러 대응

<img src="https://user-images.githubusercontent.com/72188416/120915137-0b9f6680-c6dd-11eb-8c02-d726e618095b.png" alt="error" width=240 align=left  />



- 네트워크 통신 상황에 따른 에러 표시 구현



<img src="https://user-images.githubusercontent.com/72188416/120915136-08a47600-c6dd-11eb-8e49-a7412225f18b.png" alt="placeholder" width=240 align=left  />



- 불러올 수 없는 이미지가 있을 시 placeholder 이미지 표시

