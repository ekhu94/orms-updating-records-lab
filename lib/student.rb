require_relative "../config/environment.rb"

class Student

  def self.create_table
    sql = <<-SQL
      CREATE TABLE IF NOT EXISTS students (
        id INTEGER PRIMARY KEY,
        name TEXT,
        grade INTEGER
      );
      SQL
    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = <<-SQL
      DROP TABLE IF EXISTS students;
      SQL
    DB[:conn].execute(sql)
  end

  def self.create(name, grade)
    student = self.new(name, grade)
    student.save
    student
  end

  def self.new_from_db(arr)
    student = self.new(arr[1], arr[2], arr[0])
    student
  end

  def self.find_by_name(name)
    sql = <<-SQL
      SELECT * FROM students WHERE name = ?;
      SQL
    arr = DB[:conn].execute(sql, name).first
    self.new_from_db(arr)
  end

  attr_accessor :name, :grade
  attr_reader :id

  def initialize(name, grade, id=nil)
    @name, @grade, @id = name, grade, id
  end

  def save
    if self.id
      self.update
    else
      sql = <<-SQL
        INSERT INTO students (name, grade) VALUES (?, ?);
        SQL
      DB[:conn].execute(sql, self.name, self.grade)
      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students;")[0][0]
    end
  end

  def update
    sql = <<-SQL
      UPDATE students SET name = ?, grade = ? WHERE id = ?;
      SQL
    DB[:conn].execute(sql, self.name, self.grade, self.id)
  end

end
