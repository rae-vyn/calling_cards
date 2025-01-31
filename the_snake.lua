--[[
The Snake

This set's primary focus will be cards that accrue value over time.

The Fang: X4 mult per joker (not including self), 1 in 4 chance to destroy a random joker at the end of round
The Nest: After two rounds, sell for 50% chance to make an Egg, 25% chance to make two eggs, and 25% chance to make The Fang
The Venom: 1 in 2 chance to destroy a played card, X5 mult
Ouroboros: Keeps the ante where it is until sold.
]]

SMODS.Atlas {key = "placeholder", px = 71, py = 95, path = "Placeholder.png"}
SMODS.Atlas {key = "thefang", px = 71, py = 95, path = "TheFang.png"}

SMODS.Joker({
    key = "thefang",
    config = { extra = { xmult = 4, curr_mult = 0 } },
    loc_vars = function(self, info_queue, card)
        return { vars = {card.ability.extra.xmult, card.ability.extra.curr_mult}}
    end,
    rarity = 2,
    atlas = "thefang",
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
