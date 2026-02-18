# SLA Lite — 1인 SaaS 서비스 수준 약속

> 이 템플릿은 1인/소규모 SaaS가 고객에게 약속할 수 있는 현실적인 서비스 수준 합의서(SLA)입니다.
> 빈칸(___) 을 채우고 웹사이트 또는 이용약관 페이지에 게시하세요.
> ⚠️ 법적 효력이 필요한 경우 변호사 검토를 받으세요.

---

## 서비스 수준 약속 / Service Level Agreement

**서비스명**: ___
**운영 주체**: ___ (1인 사업자/법인명)
**시행일**: YYYY년 MM월 DD일
**최종 수정일**: YYYY년 MM월 DD일

---

### 1. 서비스 가용률 / Service Availability

| 항목 | 약속 | 비고 |
|------|------|------|
| 월간 가용률 목표 | 99.5% | 월 약 3.6시간 이내 다운타임 허용 |
| 정기 점검 시간 | 매주 ___요일 ___시~___시 (KST) | 사전 고지, 가용률 산정에서 제외 |
| 긴급 점검 | 필요 시 수시 | 가능한 한 1시간 전 고지 |

> **가용률 산출 방법**: (총 시간 - 비계획 다운타임) / 총 시간 x 100
> 정기 점검, 고객 측 네트워크 문제, 제3자 서비스(AWS, Vercel 등) 장애는 제외합니다.

**Service Availability**: We target 99.5% monthly uptime, excluding scheduled maintenance windows and third-party outages.

---

### 2. 고객 지원 응답 시간 / Support Response Time

| 긴급도 | 설명 | 최초 응답 | 해결 목표 |
|--------|------|----------|----------|
| 긴급 (Critical) | 서비스 전체 접속 불가 | 4시간 이내 | 24시간 이내 |
| 높음 (High) | 핵심 기능 장애 | 영업일 12시간 이내 | 영업일 3일 이내 |
| 보통 (Normal) | 일반 문의, 기능 요청 | 영업일 24시간 이내 | 영업일 5일 이내 |
| 낮음 (Low) | 개선 제안, 피드백 | 영업일 48시간 이내 | 가능 시 반영 |

| 항목 | 내용 |
|------|------|
| 지원 채널 | ___ (예: 이메일 support@___.com, 인앱 채팅) |
| 운영 시간 | 평일 ___시~___시 (KST), 주말/공휴일 제외 |
| 언어 | 한국어 / English |

> **1인 운영 참고**: 동시 다수 문의 시 순차 대응합니다. 긴급 장애는 최우선 처리합니다.

**Support Response**: First response within 24 business hours for standard inquiries. Critical outages are prioritized within 4 hours during business hours.

---

### 3. 데이터 보호 및 백업 / Data Protection & Backup

| 항목 | 약속 | 비고 |
|------|------|------|
| 데이터 백업 주기 | 매일 1회 자동 백업 | ___ 시점 기준 |
| 백업 보관 기간 | 최근 ___일 (최소 7일 권장) | |
| 데이터 복원 요청 | 영업일 기준 48시간 이내 처리 | 복원 범위에 따라 소요 시간 다름 |
| 데이터 암호화 | 전송 중(TLS 1.2+), 저장 시(AES-256) | |
| 데이터 소유권 | 고객의 데이터는 고객의 소유입니다 | |
| 서비스 종료 시 | 종료 30일 전 고지, 데이터 내보내기 제공 | |

**Data Protection**: Daily automated backups retained for at least 7 days. Your data belongs to you. Full data export is available at any time.

---

### 4. 환불 정책 / Refund Policy

| 조건 | 환불 기준 |
|------|----------|
| 가입 후 14일 이내 | 무조건 전액 환불 (사유 불문) |
| 연간 결제 중도 해지 | 미사용 잔여 기간 일할 계산 환불 |
| 월간 결제 해지 | 결제 주기 종료까지 이용 가능, 부분 환불 없음 |
| 서비스 장애로 인한 피해 | 다운타임 비율만큼 크레딧 보상 |
| 환불 처리 기간 | 요청일로부터 영업일 ___일 이내 |

**환불 신청 방법**: ___ (예: support@___.com으로 이메일 발송)

**Refund Policy**: Full refund within 14 days of purchase, no questions asked. Annual plans are refunded pro-rata for unused months.

---

### 5. 서비스 변경 고지 / Change Notification

| 변경 유형 | 사전 고지 기간 | 고지 방법 |
|----------|-------------|----------|
| 요금 변경 | 30일 전 | 이메일 + 인앱 알림 |
| 주요 기능 제거 | 30일 전 | 이메일 + 인앱 알림 |
| 이용약관 변경 | 14일 전 | 이메일 |
| 정기 점검 | 24시간 전 | 인앱 알림 또는 상태 페이지 |
| 긴급 점검 | 최대한 사전 고지 | 상태 페이지 |
| 서비스 종료 | 90일 전 | 이메일 + 인앱 알림 |

> **기존 요금 보장**: 요금 인상 시 기존 유료 고객은 결제 주기 종료 시까지 기존 요금이 적용됩니다.

**Change Notification**: Pricing and major feature changes are communicated via email at least 30 days in advance.

---

### 6. 면책 조항 / Disclaimer

> 이 서비스는 1인 운영자가 개발하고 관리합니다. 아래 한계를 솔직하게 알려드립니다.

| 한계 | 설명 |
|------|------|
| 24시간 모니터링 미제공 | 자동 모니터링은 운영 중이나, 야간/주말 즉시 대응이 어려울 수 있습니다 |
| SLA 위반 시 보상 한계 | 최대 보상은 해당 월 결제 금액의 100%입니다 (크레딧) |
| 제3자 서비스 장애 | 호스팅(Vercel, AWS 등), 결제(Stripe 등) 장애는 통제 범위 밖입니다 |
| 천재지변/불가항력 | 자연재해, 전쟁, 정부 규제 등으로 인한 중단은 면책됩니다 |

**솔직한 약속**: 1인 운영이지만 고객 데이터와 서비스 안정성을 최우선으로 여깁니다. 문제가 생기면 빠르고 투명하게 소통하겠습니다.

**Disclaimer**: This service is operated by a solo founder. While we employ automated monitoring and daily backups, 24/7 instant response is not guaranteed. Maximum liability is limited to 100% of the monthly fee paid.

---

### 7. 상태 페이지 / Status Page

| 항목 | 내용 |
|------|------|
| 상태 페이지 URL | ___ (예: https://status.___.com) |
| 장애 이력 공개 | 예 |
| RSS/이메일 구독 | 예 / 아니오 |

> 실시간 서비스 상태는 위 상태 페이지에서 확인할 수 있습니다.

**Status Page**: Real-time service status and incident history are available at the URL above.

---

### 8. 연락처 / Contact

| 항목 | 내용 |
|------|------|
| 이메일 | support@___.com |
| 긴급 연락 | ___ (예: 상태 페이지 긴급 알림) |
| 사업자 정보 | ___ |

---

> **이 문서의 사용법**
> 1. 빈칸(___) 을 채우세요
> 2. 자사 서비스에 맞지 않는 항목은 수정하거나 삭제하세요
> 3. 웹사이트 하단 또는 이용약관 페이지에 게시하세요
> 4. 변경 이력을 기록하고, 변경 시 고객에게 알리세요
>
> **팁**: 처음에는 보수적으로 약속하고, 실적이 쌓이면 더 높은 수준을 제시하세요. 약속은 지킬 수 있는 범위 안에서.
