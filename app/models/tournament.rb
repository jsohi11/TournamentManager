# encoding: UTF-8
class Tournament < ActiveRecord::Base
    #has_and_belongs_to_many :teams #this would allow teams to persist across time.
    # This is not desirable, since rosters and amtaid's change over a season.
    # Hence, new teams for each tournament, hence has_many relationship
    has_and_belongs_to_many :teams
    has_many :rounds, :dependent => :destroy
    has_many :pairings, :through => :rounds
    belongs_to :user, :foreign_key => "owner_id"
    
    validates :title, :presence => true, :length => {:minimum => 3 }
    validates :location, :presence => true
    validates :start_date, :presence => true
    validates :end_date, :presence => true
    validate :end_date_is_after_start_date, :tournament_is_in_the_future

    serialize :rooms


    def end_date_is_after_start_date
      errors.add(:end_date, "can't be before start date") if end_date < start_date
    end

    def tournament_is_in_the_future
      errors.add(:start_date, "You can't create a tournament in the past! (Unless you have a time machine. If you do, please contact us...)") if start_date < Date.today
    end

    #also has info, URLs to packet pdf, map pdf, Google MyMaps?,
    #if we add ads, relationship to ads

    def translate(type, string)
      tournament_format_strings = Hash.new
      amta_strings = Hash.new
      amta_strings["Aff"] = "Plaintiff/Prosecution"
      amta_strings["Neg"] = "Defense"
      amta_strings["aff"] = "π"
      amta_strings["neg"] = "Δ"
      
      tournament_format_strings["AMTA"] = amta_strings
      if !type or type.empty?
        return tournament_format_strings["AMTA"][string]
      else
        return tournament_format_strings[type][string]
      end
    end
end
