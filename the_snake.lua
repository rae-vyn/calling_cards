--[[
The Snake

This set's primary focus will be cards that accrue value over time.

The Fang: X4 mult per joker (not including self), 1 in 4 chance to destroy a random joker at the end of round
]]

SMODS.Atlas {key = "placeholder", px = 71, py = 95, path = "Placeholder.png"}

SMODS.Joker({
    key = "thefang",
    loc_txt = {
        name = "The Fang",
        text = {
            "{C:white,X:mult}X#1#{} Mult for each",
            "Joker, {C:green}1 in 4{} chance",
            "to destroy random Joker",
            "{C:inactive,s:0.8}This card not included",
            "(currently {C:white,X:mult}X#2#{} Mult)"
        }
    },
    config = { extra = { xmult = 4, curr_mult = 0 } },
    loc_vars = function(self, info_queue, card)
        return { vars = {card.ability.extra.xmult, card.ability.extra.curr_mult}}
    end,
    rarity = 2,
    atlas = "placeholder", -- TODO: Make art
    pos = {x = 0, y = 0},
    cost = 4,
    blueprint_compat = true,
    update = function(self, card, dt)
        if G.STAGE == G.STAGES.RUN then
            card.ability.extra.curr_mult = card.ability.extra.xmult * #G.jokers.cards - 1
        end
    end,
    calculate = function(self, card, context)
        if context.joker_main and card.ability.extra.curr_mult > 0 then
            return {
                x_mult = card.ability.extra.curr_mult
            }
        end
    end
})      