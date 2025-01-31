--[[
The Snake

This set's primary focus will be cards that accrue value over time.

The Fang: X4 mult per joker (not including self), 1 in 4 chance to destroy a random joker at the end of round
]]

SMODS.Atlas {key = "placeholder", px = 71, py = 95, path = "Placeholder.png"}
SMODS.Atlas {key = "thefang", px = 71, py = 95, path = "TheFang.png"}

SMODS.Joker({
    key = "thefang",
    loc_txt = {
        name = "The Fang",
        text = {
            "{C:white,X:mult}X#1#{} Mult per",
            "Joker, {C:green}1 in 4{}",
            "chance to destroy",
            "random Joker at",
            "end of round",
            "{C:inactive,s:0.8}This card not included",
            "(currently {C:white,X:mult}X#2#{} Mult)"
        }
    },
    config = { extra = { xmult = 4, curr_mult = 0 } },
    loc_vars = function(self, info_queue, card)
        return { vars = {card.ability.extra.xmult, card.ability.extra.curr_mult}}
    end,
    rarity = 2,
    atlas = "thefang", -- TODO: Make art
    pos = {x = 0, y = 0},
    cost = 4,
    blueprint_compat = true,
    update = function(self, card, dt)
        if G.STAGE ~= G.STAGES.RUN then
            return
        end
        card.ability.extra.curr_mult = card.ability.extra.xmult * (#G.jokers.cards - 1)
    end,
    calculate = function(self, card, context)
        if context.joker_main and card.ability.extra.curr_mult > 0 then
            return {
                Xmult_mod = card.ability.extra.curr_mult,
                message = localize {
                    type = 'variable',
                    key = 'a_xmult',
                    vars = {card.ability.extra.curr_mult}
                }
            }
        end
        if context.end_of_round and context.main_scoring then
            if pseudorandom(pseudoseed("j_ccs_thefang")) < 0.75 then
                return {
                    message = "Safe!"
                }
            end
            local chosen = pseudorandom_element(G.jokers.cards, pseudoseed('j_ccs_thefang'))
            while chosen.config.center_key == 'j_ccs_thefang' do
                chosen = pseudorandom_element(G.jokers.cards, pseudoseed('j_ccs_thefang'))
            end
            chosen:start_dissolve()
        end
    end
})


-- Testing:

SMODS.Atlas { key = "exam", px = 71, py = 95, path = "Exam.png"}


SMODS.Joker {
    key = 'exam',
    loc_txt = {
        name = 'Exam',
        text = {
            "Gains {C:white,X:mult}X0.25{} Mult",
            "per {C:attention}Ace{} played",
            "with a modifier",
            "(currently {C:white,X:mult}X#1#{})"
        }
    },

    config = {extra = { xmult = 0 } },

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.mult} }
    end,
    rarity = 2,
    atlas = "exam",
    pos = {x = 0, y = 0},
    cost = 2,
    blueprint_compat = true,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            -- Check for enhanced aces
            if #SMODS.get_enhancements(context.other_card) > 0 and context.other_card:get_id() == 14 then
                card.ability.extra.xmult = card.ability.extra.xmult + 0.25
            end
        end
        if context.joker_main then
            return {
                xmult = card.ability.extra.xmult
            }
        end
    end
}
