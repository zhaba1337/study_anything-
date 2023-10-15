
def float_to_fraction(float_number)

end



class Number

    attr_accessor :numerator
    attr_accessor :denominator

    def initialize(numerator = 0, denominator = 1)
        case numerator
        when Integer# отдельное задание числителя и знаменателя
            @numerator = numerator
            @denominator = denominator

        when String
            if(numerator.include?('/'))# определение ввода элемента как рациональную дробь вида a/b
                my_number_in_string = numerator.split('/')
                @numerator = my_number_in_string[0].to_i
                @denominator = my_number_in_string[1].to_i
            else# строка как int
                @numerator = numerator.to_i
                @denominator = denominator.to_i
            end

        when Array# ввод числителя и знаменателя как массив [a, b] = a/b
            @numerator = numerator[0].to_i
            @denominator = numerator[1].to_i

        when Float, Number# если float или объект моего класса Number НУЖНО ПЕРЕПИСАТЬ ДЛЯ int т.к. стоковый numerator и denominator работает криво
            @numerator = numerator.numerator
            @denominator = numerator.denominator

        end

        gcd = @numerator.gcd(@denominator)
        @numerator /= gcd
        @denominator /= gcd

    end

    def +(new_number)
        new_numerator = @numerator * new_number.denominator + new_number.numerator * @denominator
        new_denominator = @denominator * new_number.denominator

        Number.new(new_numerator, new_denominator)
    end

    def -(new_number)
        new_numerator = @numerator * new_number.denominator - new_number.numerator * @denominator
        new_denominator = @denominator * new_number.denominator

        Number.new(new_numerator, new_denominator)
    end

    def *(new_number)
        new_numerator = @numerator * new_number.numerator
        new_denominator = @denominator * new_number.denominator

        Number.new(new_numerator, new_denominator)
    end

    def /(new_number)
        new_numerator = @numerator * new_number.denominator
        new_denominator = @denominator * new_number.numerator

        Number.new(new_numerator, new_denominator)
    end

    def show
        puts "#{@numerator}/#{@denominator}"
    end


end


class Vector
    attr_accessor :vector

    def initialize(*args)

        case args
        when Vector
            @vector = args
        else
            @vector = Array.new()
            for i in args do
                @vector.append(Number.new(i))
            end
        end

    end

    def push(new_element_vector)
        @vector.append(Number.new(new_element_vector))
    end

    def show
        output_string = ""

        @vector.each do |i|
            output_string +=  "#{i.numerator}/#{i.denominator} "
        end

        puts output_string
    end

    def + (new_vector)
        result_vector = Vector.new()
        (0..@vector.length-1).each do |i|
            result_vector.push(@vector[i]+new_vector.vector[i])
        end
        result_vector
    end

    def - (new_vector)
        result_vector = Vector.new()
        (0..@vector.length-1).each do |i|
            result_vector.push(@vector[i]-new_vector.vector[i])
        end
        result_vector
    end

    def * (scalar)# не умножение векторов а умножение на скаляр
        out_vector = Vector.new()
        scalar = Number.new(scalar)
        @vector.each do |i|

            out_vector.push(i*scalar)
        end
        out_vector
    end
end

class Matrix
    attr_accessor :matrix

    def initialize(*args)
        @matrix = Array.new()
        for i in args
            @matrix.append(i)
        end
    end

    def show
        for i in @matrix
            output_string = ''
          for j in i.vector
            output_string += "#{j.numerator}/#{j.denominator} "
          end
          puts output_string
        end
    end

    def push (new_element)

        case new_element
        when Vector
            @matrix.append(new_element)
        when Array
            @matrix.append(Vector.new(*new_element))
        end

    end


    def + (new_matrix)

        if (@matrix.length == new_matrix.matrix.length && @matrix[0].vector.length == new_matrix.matrix[0].vector.length)# проверка размерности
            out_matrix = Matrix.new()
            (0..@matrix.length-1).each{|i|
                vector_for_out_matrix = Vector.new()
                (0..@matrix[i].vector.length-1).each{|j|
                    vector_for_out_matrix.push(@matrix[i].vector[j] + new_matrix.matrix[i].vector[j])
                }
                out_matrix.push(vector_for_out_matrix)
            }
            out_matrix
        end
    end

    def - (new_matrix)
        if (@matrix.length == new_matrix.matrix.length && @matrix[0].vector.length == new_matrix.matrix[0].vector.length)# проверка размерности
            out_matrix = Matrix.new()
            (0..@matrix.length-1).each{|i|
                vector_for_out_matrix = Vector.new()
                (0..@matrix[i].vector.length-1).each{|j|
                    vector_for_out_matrix.push(@matrix[i].vector[j] - new_matrix.matrix[i].vector[j])
                }
                out_matrix.push(vector_for_out_matrix)
            }
            out_matrix
        end
    end

    def * (new_matrix)
        if (@matrix.length == new_matrix.matrix[0].vector.length && @matrix[0].vector.length == new_matrix.matrix.length)# проверка размерности
            out_matrix = Matrix.new()
            (0..@matrix.length-1).each { |i|
                vector_for_out_matrix = Vector.new()
                (0..@matrix[i].vector.length-1).each { |j|
                    value_element_matrix = Number.new(0)
                    (0..@matrix[i].vector.length-1).each { |k|
                        #@matrix[i].vector[k].show
                        #new_matrix.matrix[k].vector[j].show
                        value_element_matrix += (@matrix[i].vector[k] * new_matrix.matrix[k].vector[j])
                    }
                    vector_for_out_matrix.push(value_element_matrix)
                }
                out_matrix.push(vector_for_out_matrix)
            }
            out_matrix
        end
    end

end



v1 = Vector.new(1, 4, 1)
v2 = Vector.new(4, 5, 6)
v3 = Vector.new(6, 7, 1)
m1 = Matrix.new(v1, v2, v3)
m2 = Matrix.new(v1, v2, v3)

(m1*m2).show
