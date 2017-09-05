class Event < ApplicationRecord
  has_many :groups
  has_many :user_groups, through: :groups
  has_many :users, through: :user_groups

  def assign_user_to_group(user)
  	errors = []
  	if user.part_of_event?(self)
  	  errors << "You are already part of this event"
  	else
  	  begin
        # @group = groups.vacant(self).order("RANDOM()").first
        @group = groups.order("RANDOM()").first
      end while @group.users.size >= max_no_of_user_per_group
      @group.user_groups.create(user_id: user.id)
  	end
  	[@group, errors]
  end

  def cleaning?
    name.downcase == 'cleaning'
  end

  def cooking?
    name.downcase == 'cooking'
  end

  def next_group(group)
    groups.order(:id).where('id>?', group.id).first || groups.order(:id).first
  end

  def next_date(group, count=nil)
    date = group ? group.event_date : Time.now.utc.to_date
    next_business_day(date, count)
  end

  def next_business_day(date, count)
    if count
      skip_weekends(date, count)
    else
      interval >= 1 ? skip_weekends(date, interval) : skip_weekends(date, 1)
    end
  end

  def skip_weekends(date, inc)
    date += inc
    while (date.wday % 7 == 0) or (date.wday % 7 == 6) do
      date += inc
    end
    date
  end

  def next_slot(current_group, next_group)
    if current_group.event_date.friday?
      next_group.event_date = next_date(current_group)
      next_group.evening!
    else
      if current_group.evening?
        next_group.event_date = next_date(current_group)
        next_group.morning!
      else
        next_group.event_date = current_group.event_date
        next_group.evening!
      end
    end
  end

  def move_to_next_slot(group)
    if group.event_date.friday?
      group.event_date = next_date(group)
      group.evening!
    else
      if group.evening?
        group.event_date = next_date(group)
        group.morning!
      else
        group.evening!
      end
    end
  end
end
