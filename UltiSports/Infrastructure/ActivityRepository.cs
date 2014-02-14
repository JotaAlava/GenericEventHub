﻿using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using UltiSports.Models;

namespace UltiSports.Infrastructure
{
    public class ActivityRepository : BaseRepository<Activity>, IActivityRepository
    {
        public ActivityRepository(IGenericRepository<Activity> repo) : base(repo)
        {
        }

        public IEnumerable<Activity> GetActivitiesFor(string dayOfWeek)
        {
            return _repo.Get(x => x.DayOfTheWeek.Equals(dayOfWeek));
        }

        public IEnumerable<Activity> GetAllActivities()
        {
            return _repo.Get();
        }

        public Activity GetActivityByName(string name)
        {
            return _repo.GetByID(name);
        }
    }

    public interface IActivityRepository : IBaseRepository<Activity>
    {
        IEnumerable<Activity> GetActivitiesFor(string dayOfWeek);
        UltiSports.Models.Activity GetActivityByName(string name);
        IEnumerable<UltiSports.Models.Activity> GetAllActivities();
    }
}