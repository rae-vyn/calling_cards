SMODS.Atlas {
    key = "Placeholder",
    px = 69,
    py = 93,
    path = "Placeholder.png",
}


SMODS.Joker {
    key = 'theclaw',
    loc_txt = {
        name = 'The Claw',
        text = {
        "{C:white,X:mult}+5{} Mult",
        "if hand has",
        "{C:attention}4 or more{} cards"
        }
    },

    config = { extra = { mult = 4 } },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult } }
    end,
    rarity = 2,
    atlas = 'Placeholder', -- TODO: Make art
    pos = { x = 0, y = 0 },
    cost = 2,
    calculate = function(self, card, context)
        if context.joker_main and #context.full_hand >= 4 then
        return {
            mult_mod = card.ability.extra.mult,
            message = localize { type = 'variable', key = 'a_mult', vars = { card.ability.extra.mult } }
        }
        end
    end
}