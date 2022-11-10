import { Editor } from '@tiptap/core'
import { Document } from '@tiptap/extension-document'
import { Paragraph } from '@tiptap/extension-paragraph'
import { Text } from '@tiptap/extension-text'
import { HardBreak } from '@tiptap/extension-hard-break'
import { Heading } from '@tiptap/extension-heading'
import { HorizontalRule } from '@tiptap/extension-horizontal-rule'
import { ListItem } from '@tiptap/extension-list-item'
import { BulletList } from '@tiptap/extension-bullet-list'
import { OrderedList } from '@tiptap/extension-ordered-list'
import { Bold } from '@tiptap/extension-bold'
import { Code } from '@tiptap/extension-code'
import { Italic } from '@tiptap/extension-italic'
import { Link } from '@tiptap/extension-link'
import { History } from '@tiptap/extension-history'
import { Placeholder } from '@tiptap/extension-placeholder'

/**
 *
 * @param {string} selector
 * @returns {Editor}
 */
const roleUpTipTap = function(selector) {
    //
    return new Editor({
        element: document.querySelector('.element'),
        extensions: [
            Document, Paragraph, Text, HardBreak,
            Heading.configure({
                levels: [2, 3, 4],
            }),
            HorizontalRule,
            ListItem, BulletList, OrderedList,
            Bold, Code, Italic,
            Link.configure({
                openOnClick: false,
            }),
            History,
            Placeholder.configure({
                placeholder: 'My Custom Placeholder',
            })
        ],
        content: '<p>Hello World!</p>',
    })
}

window.roleUpTipTap = roleUpTipTap
