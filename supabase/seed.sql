INSERT INTO public.members (id, lastname, firstname, birthday, mobile, img, labels) VALUES
(15175, 'Smith', 'John', '1992-05-13', '555-123-4567', ''         , '["Probetraining"]'),
(12793, 'Johnson', 'Emily', '1989-11-25', '555-987-6543', ''      , '["Aktiv"]'),
(20965, 'Doe', 'Michael', '2001-04-18', '555-555-5555', ''        , '["Aktiv", "Erwachsenentrainer"]'),
(14214, 'Brown', 'Sophia', '2000-07-30', '555-888-9999', ''       , '["Aktiv", "Hilfstrainer"]'),
(17251, 'Jones', 'Oliver', '1998-02-12', '555-123-9876', ''       , '["Probetraining"]'),
(3249 , 'Martinez', 'Ava', '1996-08-15', '555-654-3210', ''       , NULL),
(20977, 'Wilson', 'William', '1997-01-23', '555-654-0000', ''     , '["Passiv"]'),
(10093, 'Garcia', 'Isabella', '1999-10-27', '555-111-2222', ''    , '["Aktiv", "Hilfstrainer"]'),
(14250, 'Anderson', 'Daniel', '1994-06-11', '555-222-3333', ''    , '["Aktiv", "J&S Coach"]'),
(10760, 'Thomas', 'Emma', '2002-03-05', '555-333-4444', ''        , '["Aktiv"]'),
(3259,  'Rodriguez', 'David', '1995-09-19', '555-444-5555', ''    , '["Probetraining"]'),
(20765, 'Hernandez', 'Charlotte', '1990-12-22', '555-777-8888', '', '["Gast"]'),
(20964, 'Lewis', 'Lucas', '1993-03-27', '555-999-0000', ''        , '["Aktiv"]'),
(13481, 'Young', 'Amelia', '1988-04-29', '555-123-3210', ''       , '["Aktiv"]'),
(24442, 'Hall', 'Benjamin', '2001-05-21', '555-234-5678', ''      , '["Aktiv"]');


INSERT INTO public.trainings (id, title, weekday, section, "dateFrom", "dateTo") VALUES
(48, 'Judo Kinder Montag', 'Monday', 'Judo', '18:30', '19:45'),
(47, 'Judo Erwachsene', 'Monday', 'Judo', '20:00', '21:30'),
(50, 'Aikido Erwachsene', 'Tuesday', 'Aikido', '20:00', '21:30'),
(46, 'Judo Randori/Judofit', 'Wednesday', 'Judo', '20:00', '21:30'),
(49, 'Judo Kinder Donnerstag', 'Thursday', 'Judo', '18:00', '19:15'), 
(51, 'Aikido Donnerstag', 'Thursday', 'Aikido', '19:00', '21:30'), 
(44, 'Judo Kinder Freitag', 'Friday', 'Judo', '17:30', '18:45'),
(45, 'Judo Jugend Freitag', 'Friday', 'Judo', '18:30', '19:45'), 
(43, 'Judo Erwachsene', 'Friday', 'Judo', '20:00', '21:30');
