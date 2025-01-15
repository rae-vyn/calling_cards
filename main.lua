-- Atlasses
SMODS.Atlas {key = "Placeholder", px = 71, py = 95, path = "Placeholder.png"}
SMODS.Atlas {key = "TheClaw", px = 71, py = 95, path = "Claw2.png"}
SMODS.Atlas {key = "TheFeather", px = 71, py = 95, path = "TheFeather2.png"}
SMODS.Atlas {key = "TheEye", px = 71, py = 95, path = "TheEye.png"}
SMODS.Atlas {key = "TheBones", px = 71, py = 95, path = "TheBones.png"}


-- The Claw
SMODS.Joker {
    key = 'theclaw',
    loc_txt = {
        name = 'The Claw',
        text = {
            "{C:mult}+5{} Mult", 
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
    blueprint_compat = true,
    calculate = function(self, card, context)
        if context.individual and not context.end_of_round then
            if #context.full_hand >= 4 then
                return {
                    mult = card.ability.extra.mult
                }
            end
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
    rarity = 2,
    atlas = "TheFeather",
    pos = {x = 0, y = 0},
    cost = 4,
    blueprint_compat = true,
    calculate = function(self, card, context)
        if context.before then
            local hand_size = #context.scoring_hand
            local _card = copy_card(context.scoring_hand[hand_size],
                                    nil, nil, G.playing_card, true)
            _card:set_seal()
            _card:set_ability(G.P_CENTERS.c_base)
            _card:add_to_deck()
            G.deck.config.card_limit = G.deck.config.card_limit + 1
            G.deck:emplace(_card)
            table.insert(G.playing_cards, _card)

            return {
                message = "Copied!"
            }
        end
    end
}
-- The Eye
SMODS.Joker {
    key = "theeye",
    loc_txt = {
        name = "The Eye",
        text = {
            "Each Joker bought", 
            "becomes {C:dark_edition}Negative{};",
            "{C:money}$#1#{} in addition to",
            "the inflated cost."
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.money } }
    end,
    config = { extra = { money = -9} },
    rarity = 3,
    atlas = "TheEye",
    pos = {x = 0, y = 0},
    cost = 4,
    blueprint_compat = false,
    calculate = function(self, card, context)
        if context.buying_card and not context.blueprint then
            context.card:set_edition("e_negative")
            ease_dollars(card.ability.extra.money)
            card_eval_status_text(card, 'extra', nil, nil, nil, {message = '$'..card.ability.extra.money, colour = G.C.GOLD})
            return
        end
    end
}

-- The Bones
SMODS.Joker {
    key = "thebone",
    loc_txt = {
        name = "The Bone",
        text = {
            "All discarded",
            "Glass cards {C:red}break{},",
            "gains {C:attention}double{}" ,
            "{C:attention}their ranks{} as Mult", 
            "(Currently {C:mult}+#1#{} Mult)"
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = {card.ability.extra.mult} }
    end,
    config = { extra = {mult = 0}},
    rarity = 2,
    atlas = "TheBones", 
    pos = {x = 0, y = 0},
    cost = 4,
    blueprint_compat = true,
    calculate = function(self, card, context)
        if context.discard and not context.blueprint then
            if context.other_card.ability.effect == 'Glass Card' then
                card.ability.extra.mult = card.ability.extra.mult + 2 * context.other_card:get_id()
                context.other_card:shatter()
            end
        end
        if context.joker_main and card.ability.extra.mult > 0 then
            return {
                mult_mod = card.ability.extra.mult,
                message = localize { type = 'variable', key = 'a_mult', vars = { card.ability.extra.mult } }
            }
        end
    end
}