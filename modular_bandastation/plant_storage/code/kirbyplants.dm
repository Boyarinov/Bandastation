/obj/item/kirbyplants/Destroy()
	if(storage)
		storage.forceMove(storage.drop_location())
		storage.dropped()
		storage = null
	. = ..()


/obj/item/kirbyplants/item_interaction_secondary(mob/living/user, obj/item/tool, list/modifiers)
	if(user.combat_mode || (tool.item_flags & ABSTRACT) || (tool.flags_1 & HOLOGRAM_1))
		return ITEM_INTERACT_SKIP_TO_ATTACK

	src.Shake(1, 0, 3 SECONDS, 0.2 SECONDS)
	if (do_after(user, 3 SECONDS, src))
		var/obj/item/item_from_storage = storage
		var/result = FALSE
		var/null_the_storage = TRUE

		// trying to put item in storage
		if (tool.w_class <= WEIGHT_CLASS_SMALL)
			if(!user.transferItemToLoc(tool, src))
				return NONE
			tool.do_pickup_animation(src, usr.loc)
			storage = tool
			null_the_storage = FALSE
			result = TRUE
		else
			balloon_alert(user, "Предмет не вмещается")


		if(!QDELETED(item_from_storage))
			item_from_storage.do_pickup_animation(user, src.loc)
			user.put_in_hands(item_from_storage)
			if (null_the_storage)
				storage = null
			result = TRUE

		if (result)
			return ITEM_INTERACT_SUCCESS
	// stop animation early if we stop the interaction
	else
		animate(src, null)

	return NONE



/obj/item/kirbyplants/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return

	src.Shake(1, 0, 3 SECONDS, 0.2 SECONDS)
	if (do_after(user, 3 SECONDS, src))
		if(!QDELETED(storage))
			storage.do_pickup_animation(user, src.loc)
			user.put_in_hands(storage)
			storage = null
	// stop animation early if we stop the interaction
	else
		animate(src, null)

	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN


/obj/item/kirbyplants/add_context(atom/source,
	list/context,
	obj/item/held_item,
	mob/living/user,
)
	if (!held_item)
		context[SCREENTIP_CONTEXT_LMB] = "Взять"
		context[SCREENTIP_CONTEXT_RMB] = "Обыскать"
		return CONTEXTUAL_SCREENTIP_SET

	if (held_item.w_class <= WEIGHT_CLASS_SMALL)
		context[SCREENTIP_CONTEXT_RMB] = "Спрятать"
		return CONTEXTUAL_SCREENTIP_SET
	return .
