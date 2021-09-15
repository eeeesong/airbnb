# airbnb✈️

숙박 예약 앱 **airbnb** 클론 프로젝트

> [코드스쿼드](https://github.com/codesquad-members-2021/airbnb) 마스터즈 코스에서 진행한 프로젝트입니다.

- `개발 기간` 2021년 5월 17일 ~ 6월 4일
- `팀` iOS 1인 (with 백엔드 1인, 웹프론트엔드 1인) / + 코드 리뷰어 1인
- `주요 개발 키워드` MVVM, Custom Calendar & Graph (Code-based), Network Test

#### iPhone11 구동 화면

<img src="https://user-images.githubusercontent.com/72188416/120914487-78b0fd00-c6d9-11eb-8dd6-a1353c8698ab.gif" alt="앱의 전반적인 흐름" width=280>

<br>

## 상세 개발 내용

### MVVM 
- ViewModel을 통한 데이터 바인딩을 통해 ViewController의 역할을 축소하고, 데이터 흐름을 가시화했습니다.

```swift
// PopularLocationViewController
private func bind() {
    viewModel?.bind { [weak self] popularLocation in
        self?.updateTableView(with: popularLocation)
    } errorHandler: { [weak self] error in
        self?.alertError(error: error)
    }
}
```

- [코드 리뷰](https://github.com/codesquad-members-2021/airbnb/pull/7) 진행 후, 중복된 ViewModel 코드가 가독성을 해친다는 것을 알게되었습니다.
- Protocol과 Generic을 활용해 ViewModel의 중복코드를 개선하였습니다.

```swift
protocol NetworkResultHandleModel {
    associatedtype Result
    typealias DataHandler = (Result) -> Void
    typealias ErrorHandler = (Error) -> Void
    func bind(dataHandler: @escaping DataHandler, errorHandler: @escaping ErrorHandler)
}

class AnyResultHandleModel<ResultData>: NetworkResultHandleModel {
    
    typealias Result = ResultData
    
    private(set) var dataHandler: DataHandler?
    private(set) var errorHandler: ErrorHandler?
    
    func bind(dataHandler: @escaping DataHandler, errorHandler: @escaping ErrorHandler) {
        self.dataHandler = dataHandler
        self.errorHandler = errorHandler
    }
}
```




### Custom Calendar
#### 흐름

<img width="900" alt="스크린샷 2021-09-15 오후 7 41 57" src="https://user-images.githubusercontent.com/72188416/133419333-c5cf8caa-6702-4f77-8c79-57bad4dfe407.png">

- IndexPath의 대소 비교 시, Section이 다를 경우에 제대로된 비교가 어려웠습니다.
- 이러한 어려움을 해결하고자 CalendarCoordinate 타입을 새로 생성하고, Comparable 프로토콜을 채택하여 비교식을 작성했습니다.

```swift
struct CalendarCoordinate {
    let month: Int
    let day: Int

    init(with indexPath: IndexPath) {
        self.month = indexPath.section
        self.day = indexPath.row
    }
    
    enum MonthRelationship {
        case same
        case continuous
        case away
    }
    
    static func relationship(between first: CalendarCoordinate,_ second: CalendarCoordinate) -> MonthRelationship {
        let monthDiff = abs(first.month - second.month)
        switch monthDiff {
        case 0:
            return .same
        case 1:
            return .continuous
        default:
            return .away
        }
    }
}

extension CalendarCoordinate: Comparable {
    static func < (lhs: CalendarCoordinate, rhs: CalendarCoordinate) -> Bool {
        let sameMonth = lhs.month == rhs.month && lhs.day < rhs.day
        let differentMonth = lhs.month < rhs.month
        return sameMonth || differentMonth
    }
}
```

- 그리고 날짜가 이틀 이상 선택된 경우의 상태 업데이트 시, 이를 적극 활용하였습니다.

```swift
// CalendarManager
func changeMultipleDays(fromCoord: CalendarCoordinate, toCoord: CalendarCoordinate, to status: SelectStatus) {
    let relationship = CalendarCoordinate.relationship(between: fromCoord, toCoord)
    switch relationship {
    case .same:
        changeMonth(at: fromCoord.month, fromIndex: fromCoord.day, toIndex: toCoord.day, to: status)
    case .away:
        (fromCoord.month + 1..<toCoord.month).forEach { monthIndex in
            changeMonth(at: monthIndex, to: status)
        }
        fallthrough
    case .continuous:
        changeMonth(at: fromCoord.month, fromIndex: fromCoord.day, to: status)
        changeMonth(at: toCoord.month, toIndex: toCoord.day, to: status)
    }
}
```





## 화면 별 구현 내용


<img src="https://user-images.githubusercontent.com/72188416/120915142-0e01c080-c6dd-11eb-8909-2df26004aaa0.png" alt="search" width=240>



- **검색 화면**
  - `UISearchController` / `UISearchResultsUpdating` 활용
  - mock networking 객체를 통한 가짜 검색 데이터 제공

<br>


<img src="https://user-images.githubusercontent.com/72188416/120914492-7f3f7480-c6d9-11eb-952f-74868818570b.png" alt="calendar" width=240>



- **달력 선택 화면**

  - `UICollectionView`를 활용한 Custom Calendar UI 구현
  - Foundation의 [Calendar](https://developer.apple.com/documentation/foundation/calendar)를 활용하여 Custom Calendar Model 구현
  - 현재와 다른 연도의 날짜 선택 시 연도 표시, 같은 연도일 경우 일/월만 표시

  
<br>

<img src="https://user-images.githubusercontent.com/72188416/120914496-85355580-c6d9-11eb-8485-e973ab332ba2.png" alt="graph2" width=240>



- **가격 선택 화면**
  - `CAShapeLayer`와 `UIBezierPath`를 활용한 Graph View 구현
  - mock API 데이터를 사용하여 가격 그래프 생성
  - [MultiSlider](https://github.com/yonat/MultiSlider) 라이브러리를 사용하여 2 thumbs slider 추가
  - `CALayer`의 `compositingFilter`를 활용하여 선택 영역 음영 추가

<br>


<img src="https://user-images.githubusercontent.com/72188416/120915138-0c37fd00-c6dd-11eb-962a-1481658cc81e.png" alt="list" width=240>



- **숙박 리스트 화면**
  - 날짜, 가격 선택에 따라 숙박 리스트 query
  - API 미구현에 따라 앱 내 가격 filter 후 데이터 노출
  - 네트워크 데이터 표시 전 스켈레톤 UI 표시
  - `CAGradientLayer`와 `CAAnimation`을 활용하여 Shimmer 생성, 적용


<br>
