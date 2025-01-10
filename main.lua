SMODS.Atlas {key = "Placeholder", px = 69, py = 93, path = "Placeholder.png"}
SMODS.Atlas {key = "TheClaw", px = 69, py = 93, path = "TheClaw.png"}
-- The Claw
SMODS.Joker {
    key = 'theclaw',
    loc_txt = {
        name = 'The Claw',
        text = {
            "{C:white,X:mult}+5{} Mult", 
            "per card", 
            "if hand has",
            "{C:attention}4 or more{} cards"
        }
    },

    config = {extra = { mult = 5 } },

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.mult} }
    end,
    rarity = 2,
    atlas = 'TheClaw',
    pos = {x = 0, y = 0},
    cost = 2,
    calculate = function(self, card, context)
        if context.joker_main and #context.full_hand >= 4 then
            return {
                mult_mod = card.ability.extra.mult * #context.full_hand,
                message = localize {
                    type = 'variable',
                    key = 'a_mult',
                    vars = {card.ability.extra.mult * #context.full_hand}
                }
            }
        end
    end
}

-- The Feather
SMODS.Joker {
    key = "thefeather",
    loc_txt = {
        name = "The Feather",
        text = {
            "Creates an {C:attention}base{}", "copy of the last",
            "card in scored hand"
        }
    },
    config = {},
    rarity = 3,
    atlas = "Placeholder", -- TODO: Make art
    pos = {x = 0, y = 0},
    cost = 4,
    calculate = function(self, card, context)
        if context.joker_main then
            local hand_size = #context.scoring_hand
            local _card = copy_card(context.scoring_hand[hand_size],
                                    nil, nil, G.playing_card, true)
            _card:set_seal()
            _card:set_ability(G.P_CENTERS.c_base)
            _card:add_to_deck()
            G.deck.config.card_limit = G.deck.config.card_limit + 1
            G.deck:emplace(_card)
            table.insert(G.playing_cards, _card)
        end
    end
}
