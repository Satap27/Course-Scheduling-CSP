include "ingegneria.dzn";
include "all_disjoint.mzn";

int: daily_hours;
int: days;
int: rooms;
enum courses;
enum teachings;
int: professors;
int: H;
int: t1;
int: t2;
array[teachings] of int: course;
array[teachings] of int: teaching_hours;
array[teachings] of int: professor;
bool: sequential;

int: total_teaching_hours = sum(teaching_hours);

array[1..days, 1..rooms, teachings] of var set of 1..daily_hours: teaching_schedule;

constraint assert(daily_hours*days*rooms >= total_teaching_hours , "Room number is not sufficient (provided: " ++ show(rooms) ++ ")");
constraint assert(t2 >= t1 , "Provided max allowed hours is less than min allowed hours");

% every teaching must appear for the agreed hours
constraint forall(teaching in teachings)( 
  sum([card(teaching_schedule[day, room, teaching]) | day in 1..days, room in 1..rooms]) = teaching_hours[teaching] 
);

% the same room can't host multiple teachings together
constraint forall(day in 1..days, room in 1..rooms)( 
  all_disjoint([teaching_schedule[day, room, teaching] | teaching in teachings])
);

% the same teaching can't take place at the same hour (and day) on a different room
constraint forall(day in 1..days, teaching in teachings)( 
  all_disjoint([teaching_schedule[day, room, teaching] | room in 1..rooms])
);

% teachings held by the same professor can't take place at the same hour (and day) on a different room
constraint forall(day in 1..days, prof in 1..professors)( 
  all_disjoint([teaching_schedule[day, room, teaching] | room in 1..rooms, teaching in teachings where professor[teaching] = prof])
);

% a professor can't teach for more than H hours everyday
constraint forall(day in 1..days, prof in 1..professors)(
  sum([card(teaching_schedule[day, room, teaching]) | room in 1..rooms, teaching in teachings where professor[teaching] = prof]) <= H
);

% there can't be less than t1 or more than t2 hours of the same teaching in a day (or there can be 0 hours)
constraint forall(day in 1..days, room in 1..rooms, teaching in teachings)(
  card(teaching_schedule[day, room, teaching]) = 0 \/
  (card(teaching_schedule[day, room, teaching]) >= t1 /\
  card(teaching_schedule[day, room, teaching]) <= t2)
);

% teachings belonging to the same course can't take place at the same hour (and day) on a different room
constraint forall(day in 1..days, c in courses)( 
  all_disjoint([teaching_schedule[day, room, teaching] | room in 1..rooms, teaching in teachings where course[teaching] = c])
);

% if sequential = true, teachings must appear sequentially in the room schedule
constraint forall(day in 1..days, room in 1..rooms, teaching in teachings)(
  not sequential \/ card(teaching_schedule[day, room, teaching]) = 0 \/
  max(teaching_schedule[day, room, teaching]) - min(teaching_schedule[day, room, teaching]) + 1 = card(teaching_schedule[day, room, teaching])
);

solve satisfy;

output [if room == 1 /\ hour == 1 then "\n\nDAY " ++ show(day) ++ "\n" else "" endif ++
        if hour == 1 then "\nROOM " ++ show_int(1,room) ++ "\n\n" else "" endif ++
        "HOUR " ++ show_int(1,hour) ++ ": " ++
        if fix(sum([teaching | teaching in teachings where hour in teaching_schedule[day,room,teaching]])) != 0 then
        show([teaching | teaching in teachings where hour in teaching_schedule[day,room,teaching]][1]) else "FREE" endif ++ "\n" |
        day in 1..days, room in 1..rooms, hour in 1..daily_hours]


