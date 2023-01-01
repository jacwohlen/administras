export enum WEEKDAY {
  Sunday = 0,
  Monday = 1,
  Tuesday = 2,
  Wednesday = 3,
  Thursday = 4,
  Friday = 5,
  Saturday = 6,
}

export interface Member {
  id: string
  firstname: string
  lastname: string
  birthday?: string
  mobile?: string
  labels?: string[]
}

export interface Training {
  id: string
  title: string
  dateFrom: string
  dateTo: string
  weekday: string
  section: string
  participants: Member[]
}

export interface Log {
  id: string // date
  members: Member[]
}
