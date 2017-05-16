#!/usr/bin/env ruby2.3
require 'gli'
require 'hacer'



include GLI::App

public def is_number? string
  true if Float(string) rescue false
end

program_desc 'A simple order scores app'

command :read do |c|
  c.action do |global_option,options,args|
    file = File.open(args[0], "rb")
    f_lines = file.read.split("\n")
    file.close
    teams = {}
    f_lines.each do |line|
      team_and_score = line.split(",")
      team1 = team_and_score[0].split(" ")
      team2 = team_and_score[1].split(" ")
      if is_number?(team2[1]) == false
        team2[0] = team2[0] + " " + team2[1]
        team2[1] = team2[2]
      end

      if team1[1] > team2[1]
        if teams.key?(team1[0]) == false
          teams[team1[0]] = []
        end
        if teams.key?(team2[0])  == false
          teams[team2[0]] = []
        end
        teams[team1[0]].push(3)
        teams[team2[0]].push(0)
      elsif team1[1] < team2[1]
        if teams.key?(team1[0])  == false
          teams[team1[0]] = []
        end
        if teams.key?(team2[0])  == false
          teams[team2[0]] = []
        end
        teams[team1[0]].push(0)
        teams[team2[0]].push(3)
      else
        if teams.key?(team1[0])  == false
          teams[team1[0]] = []
        end
        if teams.key?(team2[0])  == false
          teams[team2[0]] = []
        end
        teams[team1[0]].push(1)
        teams[team2[0]].push(1)
      end
    end
      teams.each do |team, score|
        points = 0
        score.each do |point|
          points = point.to_i + points.to_i
        end
        teams[team] =points
      end
      teams = teams.sort_by{ |k,v| [-v, -k]  }
      last_score = ""
      count = 0
      teams.each do |team, score|
        count+= 1
        if last_score.to_i == score.to_i
          p (count - 1).to_s + "." + team.to_s + "," + " " + score.to_s + " pts"
          last_score = score
        else
          p count.to_s + "." + team.to_s + "," + " " + score.to_s + " pts"
          last_score = score
        end
      end
  end
end

command :list do |c|
  c.action do
    $todo_list.list.each do |todo|
      printf("%5d - %s\n",todo.todo_id,todo.text)
    end
  end
end

command :done do |c|
  c.action do |global_options,options,args|
    id = args.shift.to_i
    $todo_list.list.each do |todo|
      $todo_list.complete(todo) if todo.todo_id == id
    end
  end
end

exit run(ARGV)
