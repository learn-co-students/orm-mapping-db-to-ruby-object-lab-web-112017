class Student
  attr_accessor :id, :name, :grade
  @@all = []

  def self.new_from_db(row) #[id, name, grade]
    a=self.new(row[0],row[1],row[2])
  end

  def self.find_by_name(name)
    a = DB[:conn].execute("SELECT * FROM students WHERE name = ?",name)[0]
    self.new(a[0],a[1],a[2])
  end

  def self.count_all_students_in_grade_9
    students = []
    a=DB[:conn].execute("SELECT * FROM students WHERE grade = 9")
    a.each {|arr| students << self.new_from_db(arr)}
    students
  end

  def self.students_below_12th_grade
    students = []
    a=DB[:conn].execute("SELECT * FROM students WHERE grade < 12")
    a.each {|arr| students << self.new_from_db(arr)}
    students
  end

  def self.all
    DB[:conn].execute("SELECT * FROM students").each do |x|
      @@all << self.new_from_db(x)
    end
    @@all
  end

  def self.first_X_students_in_grade_10(num)
    students = []
    a=DB[:conn].execute("SELECT * FROM students WHERE grade = 10 LIMIT ?", num)
    a.each {|arr| students << self.new_from_db(arr)}
    students
  end

  def self.first_student_in_grade_10
    a=DB[:conn].execute("SELECT * FROM students WHERE grade = 10 LIMIT 1")[0]
    self.new(a[0],a[1],a[2])
  end

  def self.all_students_in_grade_X(grade)
    students = []
    a=DB[:conn].execute("SELECT * FROM students WHERE grade = ?;", grade)
    a.each {|arr| students << self.new_from_db(arr)}
    students
  end

  def initialize(id=nil, name=nil, grade=nil)
    @id = id
    @name = name
    @grade = grade
  end

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end
end
