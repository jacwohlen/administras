import type { DocumentReference } from 'firebase/firestore';

export interface Member {
  id: string;
  firstname: string;
  lastname: string;
  birthday?: string;
  mobile?: string;
  labels?: string[];
  img?: string;
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
  members: Member[];
}
