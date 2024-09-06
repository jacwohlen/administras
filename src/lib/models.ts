import type { Dayjs } from "dayjs";

export interface Member {
  id: string;
  firstname: string;
  lastname: string;
  birthday?: string;
  mobile?: string;
  labels?: string[];
  img?: string;
  imgUploaded?: string | Dayjs;
}

export interface Training {
  id: string;
  title: string;
  dateFrom: string;
  dateTo: string;
  weekday: string;
  section: string;
  participants: Member[];
}

export interface Log {
  id: number;
  date: string;
  trainingId: Training;
  memberId: Member;
  isMainTrainer: boolean;
}

export interface Athletes {
  section: string;
  memberid: number;
  lastname: string;
  firstname: string;
  count: number;
  rank: number;
}
