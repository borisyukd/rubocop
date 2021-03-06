# encoding: utf-8

module Rubocop
  module Cop
    module Style
      # This cop checks for the presence of superfluous parentheses around the
      # condition of if/while/until.
      class ParenthesesAroundCondition < Cop
        include SafeAssignment

        def on_if(node)
          process_control_op(node)
        end

        def on_while(node)
          process_control_op(node)
        end

        def on_until(node)
          process_control_op(node)
        end

        private

        def process_control_op(node)
          cond, _body = *node

          if cond.type == :begin
            # allow safe assignment
            return if safe_assignment?(cond) && safe_assignment_allowed?

            add_offence(cond, :expression, message(node))
          end
        end

        def message(node)
          "Don't use parentheses around the condition of an " \
          "#{node.loc.keyword.source}."
        end

        def autocorrect(node)
          @corrections << lambda do |corrector|
            corrector.remove(node.loc.begin)
            corrector.remove(node.loc.end)
          end
        end
      end
    end
  end
end
