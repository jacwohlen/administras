import dayjs, { type Dayjs } from 'dayjs';

export enum Weekday {
  Sunday = 0,
  Monday = 1,
  Tuesday = 2,
  Wednesday = 3,
  Thursday = 4,
  Friday = 5,
  Saturday = 6
}

function weekdayToNumber(weekday: string): number {
  const weekdayEnum = (<any>Weekday)[weekday];
  console.assert(weekdayEnum !== undefined, 'Error: Weekday does not map to a number');
  return weekdayEnum;
}

function getMostRecentDateByWeekday(weekday: number): Dayjs {
  const today = dayjs();
  const mostRecentWeekday = dayjs().day(weekday);
  if (mostRecentWeekday.isAfter(today)) {
    mostRecentWeekday.subtract(7, 'days');
  }
  return mostRecentWeekday;
}

export default { weekdayToNumber, getMostRecentDateByWeekday };
